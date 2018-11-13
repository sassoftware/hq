        <c:choose>
        <c:when test="${resource.action=='start' or resource.action=='Start'}">
            <fmt:message key="resource.server.ControlStatus.Content.Start"/>
        </c:when>
        <c:when test="${resource.action=='stop' or resource.action=='Stop'}">
            <fmt:message key="resource.server.ControlStatus.Content.Stop"/>
        </c:when>
        <c:when test="${resource.action=='restart' or resource.action=='Restart'}">
            <fmt:message key="resource.server.ControlStatus.Content.Restart"/>
        </c:when>

        <c:when test="${resource.action=='Pause' or resource.action=='pause'}">
            <fmt:message key="alert.config.props.CB.Content.ControlAction.Pause"/>
        </c:when>

        <c:when test="${resource.action=='Resume' or resource.action=='resume'}">
            <fmt:message key="alert.config.props.CB.Content.ControlAction.Resume"/>
        </c:when>

        <c:when test="${resource.action=='restart_platform' or resource.action=='Restart_platform'}">
            <fmt:message key="alert.config.props.CB.Content.ControlAction.Restart_platform"/>
        </c:when>
    
        <c:when test="${resource.action=='reset_VM' or resource.action=='Reset_VM'}">
            <fmt:message key="alert.config.props.CB.Content.ControlAction.Reset_VM" />
        </c:when>

        <c:when test="${resource.action=='shutdown' or resource.action=='Shutdown'}">
            <fmt:message key="resource.server.ControlStatus.Content.Shutdown" />
        </c:when>

        <c:when test="${resource.action=='reload' or resource.action=='Reload'}">
            <fmt:message key="resource.server.ControlStatus.Content.Reload" />
        </c:when>

        <c:when test="${resource.action=='analyze' or resource.action=='Analyze'}">
            <fmt:message key="resource.server.ControlStatus.Content.Analyze" />
        </c:when>
        
        <c:when test="${resource.action=='vacuum' or resource.action=='Vacuum'}">
            <fmt:message key="resource.server.ControlStatus.Content.Vacuum" />
        </c:when>
        
        <c:when test="${resource.action=='vacuumAnalyze' or resource.action=='VacuumAnalyze'}">
            <fmt:message key="resource.server.ControlStatus.Content.VacuumAnalyze" />
        </c:when>

        <c:when test="${resource.action=='graceful' or resource.action=='Graceful'}">
            <fmt:message key="resource.server.ControlStatus.Content.Graceful" />
        </c:when>

        <c:when test="${resource.action=='gracefulstop' or resource.action=='Gracefulstop'}">
            <fmt:message key="resource.server.ControlStatus.Content.Gracefulstop" />
        </c:when>

        <c:when test="${resource.action=='configtest' or resource.action=='Configtest'}">
            <fmt:message key="resource.server.ControlStatus.Content.Configtest" />
        </c:when>
        
        <c:when test="${resource.action=='reindex' or resource.action=='Reindex'}">
            <fmt:message key="resource.server.ControlStatus.Content.Reindex" />
        </c:when>
 
        <c:when test="${resource.action=='startApplications' or resource.action=='StartApplications'}">
            <fmt:message key="resource.server.ControlStatus.Content.StartApplications" />
        </c:when>

        <c:when test="${resource.action=='stopApplications' or resource.action=='StopApplications'}">
            <fmt:message key="resource.server.ControlStatus.Content.StopApplications" />
        </c:when>
        
        <c:when test="${resource.action=='reloadApplications' or resource.action=='ReloadApplications'}">
            <fmt:message key="resource.server.ControlStatus.Content.ReloadApplications" />
        </c:when>
        
        <c:otherwise>
            ${resource.action}
        </c:otherwise>
        </c:choose>