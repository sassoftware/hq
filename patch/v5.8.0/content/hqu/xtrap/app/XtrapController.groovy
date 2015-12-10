import org.hyperic.hq.hqu.rendit.BaseController
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Locale
import org.hyperic.hq.hqu.rendit.i18n.BundleMapFacade

class XtrapController extends BaseController
{
    def ONE_SECOND = 1000;
    def ONE_MINUTE = 60 * ONE_SECOND;
    def ONE_HOUR   = 60 * ONE_MINUTE;
    def ONE_DAY    = 24 * ONE_HOUR;

    def thresholdUnits = "Units Unknown"
    def dayUnit = "Day"
    def daysUnit = "Days"
    def weekUnit = "Week"
    def weeksUnit = "Weeks"
    def yearUnit = "Year"
    def yearsUnit = "Years"
    private BundleMapFacade bundle
    // Timeplot uses ISO 8601 dates
    DateFormat DF = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ", Locale.US)

    // Timeline uses a different date format
    DateFormat TIMELINE_DF = new SimpleDateFormat("MMM dd yyyy HH:mm:ss", Locale.US)

    protected void init() {
        onlyAllowSuperUsers()
        setXMLMethods(['alerts'])
    }
    
    void setLocaleBundle(newBundle) {
        super.setLocaleBundle(newBundle)       
        bundle = newBundle       
        thresholdUnits = bundle['xthresholdUnits']
        dayUnit = bundle['xdayUnit']
        daysUnit = bundle['xdaysUnit']
        weekUnit = bundle['xweekUnit']
        weeksUnit = bundle['xweeksUnit']
        yearUnit = bundle['xyearUnit']
        yearsUnit = bundle['xyearsUnit']
    }
    def getDataRange(params) {
        def dataRange = params.getOne("data")?.toLong()
        if (!dataRange) dataRange = ONE_DAY
        dataRange
    }

    def getProjectionRange(params) {
        def projectionRange = params.getOne("projection")?.toLong()
        if (!projectionRange) projectionRange = ONE_DAY
        projectionRange
    }

    def getThreshold(params) {
        def threshold = params.getOne("threshold")
        if (!threshold || threshold.length() == 0)
            return 0
        threshold.toLong()
    }

    def getProjectionMethod() {
        new XtrapMethodSimpleRegression()
    }
    /**
     * Render method for the main index page
     */
    def index(params) {
        log.info "index: " + params

        def dataRange = getDataRange(params)
        def projectionRange = getProjectionRange(params)
        def threshold = getThreshold(params)

        // Check if a template was given
        def tid = params.getOne("tid")?.toInteger()

        // Get the measurements for this group, grouped by template
        def metrics = []
        def members = getViewedResource().getGroupMembers(user)
        members.each {
            metrics += it.getEnabledMetrics()
        }
        def templates = metrics.groupBy() { it.template }

        // If a template was selected, generate the list of measurements
        // sorted by the measurement confidence.
        def confidence = []
        def measurements = []
   
        if (tid) {
            def t = getMetricHelper().findTemplateById(tid)
            measurements = templates.get(t)
            confidence = getProjectionMethod().getConfidence(measurements,
                                                             projectionRange)
            measurements.sort { confidence.get(it.id).value }
            thresholdUnits = t.getUnits()
        }

        render(locals:[ user:user,
                        selectTemplates:getSelectTemplates(templates),
                        tid:tid,
                        measurements:measurements,
                        confidence:confidence,
                        selectRanges:getSelectRanges(),
                        data:dataRange,
                        projection:projectionRange,
                        threshold:threshold,
                        thresholdUnits:thresholdUnits])
    }

    /**
     * Render method for metric data retrieval.  This data is rendered inline
     * (no view gsp is necessary) and follows the data format defined by
     * Timeplot.
     */
    def data(params) {
        log.info "data: " + params

        def dataRange = getDataRange(params)
        def projectionRange = getProjectionRange(params)
        def threshold = getThreshold(params)

        // Load data for the given measurement
        def mid = params.getOne('mid').toInteger()
        def m = getMetricHelper().findMeasurementById(mid)
        List data = m.getData(now() - dataRange, now()).reverse()

        def res = new StringBuffer()

        if (data.size() == 0) {
            log.warn "No existing data found for measurement id " +  m.id +
                " for time range " + (now() - dataRange) + " to " + now();
            render(inline: res.toString())
            return
        }
        
        def date
        // Fill in known data setting the extrapolated values to 0.
        for (dp in data) {
            date = DF.format(new Date(dp.timestamp))
            res << "${date}, ${dp.value}, 0, ${threshold}\n"
        }

        // Bridge the actual and extrapolated data with a dummy data point one
        // second beyond the known data with the actual value as 0 and the
        // extrapolated data as the last data point.
        date = DF.format(new Date(data[-1].timestamp + ONE_SECOND))
        res << "${date}, 0, ${data[-1].value}, ${threshold}\n"

        def projectionData = getProjectionMethod().extrapolate(data, 
                                                               projectionRange)

        for (dp in projectionData) {
            date = DF.format(new Date(dp.timestamp))
            res << "${date}, 0, ${dp.value}, ${threshold}\n"
        }

        render(inline: res.toString())
    }
    
    /**
     * Render method for gathering event data for chart overlays.
     */
    def alerts(xmlResult, params) {
        def rid = params.getOne("rid").toInteger()
        xmlResult.data {
            xmlResult.event(start: TIMELINE_DF.format(new Date(now() - ONE_HOUR)),
                            title: 'My Alert',
                            'Alert text describing this event'
            )
        }
        xmlResult
    }

    public List getSelectTemplates(Map templates) {
        def res = []
        def sortedTemplates = templates.keySet().sort { it.name }
        for (t in sortedTemplates) {
            res << [code:t.id, value:t.name]
        }
        res
    }

    /**
     * Generate a list of possible ranges.  XXX: Localize
     */
    public List getSelectRanges() {
        def res = []
        def days = [1l, 2l, 7l, 14l, 28l, 91l, 182l, 365l]
        for (day in days) {
            def val
            if (day == 1) {
                val = day + ' ' + dayUnit
            } else if (day > 1 && day < 7) {
                val = day + ' ' + daysUnit
            } else if (day == 7) {
                val = day/7 + ' ' + weekUnit
            } else if (day == 365) {
                val = day/365 + ' ' + yearUnit
            } else if (day % 7 == 0) {
                val = day/7 + ' ' + weeksUnit
            } else {
                val = day + ' ' + daysUnit
            }
            long code = day * 24 * 60 * 60 * 1000
            res << [code:code.toString(), value:val]
        }
        res
    }
}
