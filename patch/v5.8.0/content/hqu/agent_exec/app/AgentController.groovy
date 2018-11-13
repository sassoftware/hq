import org.json.JSONObject
import org.json.JSONArray
import org.hyperic.hq.hqu.rendit.BaseController
import org.hyperic.hq.authz.server.session.AuthzSubjectManagerImpl as subMan
import org.hyperic.hq.authz.shared.PermissionException
import org.hyperic.hq.appdef.shared.AgentManager;
import org.hyperic.hq.context.Bootstrap;

class AgentController 
    extends BaseController
{
    private agentManager = Bootstrap.getBean(AgentManager.class);                     
    def AgentController() {
        setTemplate('standard')
    }

    private getViewedMembers() {
        def r = viewedResource
        def members
        
        // returns true iff the resource is a 4.0 agent or later
        def isRestartableAgent = {
                if (it.prototype.name == "HQ Agent") {
                    def agent = agentManager.getAgent(it.entityId)
                    // only support restarts in 4.0 agents and later
                    return (agent.version >= "4.0.0")
                }
                else return false;
        }
        
        if (r.isGroup()) {
            // only add 4.0 agents to the member list
            members = r.getGroupMembers(user).findAll(isRestartableAgent)
        } else {
            if (isRestartableAgent(r))
                members = [r]
        }
        members
    }
    
    private getCommands() {
        ['restart', 'ping', 'upgrade', 'push plugin'] 
    }
    
    private getServerPlugins() {
        def plugins = []
        File dir = Bootstrap.getResource("WEB-INF/hq-plugins").getFile();
        String[] children = dir.list();
        if (children != null) {
            for (int i=0; i<children.length; i++) {
                // Get filename of file or directory
                if (children[i].indexOf("-plugin.")>0)
                    plugins.add(children[i])
            }
        }
        plugins.sort()
    }    
    
    private getAgentBundles() {
        def bundles = []
        File dir = Bootstrap.getResource("WEB-INF/hq-agent-bundles").getFile();
        String[] children = dir.list();
        if (children != null) {
            for (int i=0; i<children.length; i++) {
                // Get filename of file or directory
                if (children[i].endsWith(".tar.gz") || children[i].endsWith(".tgz") || children[i].endsWith(".zip"))
                    bundles.add(children[i])
            }
        }
        bundles.sort()
    }
    
    def index(params) {
        def cmds = commands
        cmds.add(0, "${localeBundle['cmdSelection']}")
        def cmdFmt = [:]
        def formatters = [:]
        for (cmd in commands) {
            cmdFmt.put(cmd,[cmd])
            formatters.put(cmd,[name:cmd, desc:"Formats the ${cmd} command"])
        }
        
        def isGroup = viewedResource.isGroup()
        def members = viewedMembers
        render(locals:[ commands:cmds, bundles:agentBundles, plugins:serverPlugins, eid:viewedResource.entityId,
                        cmdFmt:cmdFmt, formatters:formatters,
                        isGroup:isGroup, groupMembers:members])
    }
    
    def pollAgent(overlord, aeid, timeout) {
        def wentDown = false
        def sleepPeriod = 10000
        while (timeout > 0) {
            try {
                agentManager.pingAgent(overlord, aeid)
                // success
                if (wentDown)
                    break
                // agent still did not restart - give it some time
                else {
                    sleep(sleepPeriod)
                    timeout -= sleepPeriod
                }
            } catch (Exception e) {
                // agent is restarting - give it some time
                wentDown = true
                sleep(sleepPeriod)
                timeout -= sleepPeriod
            }
        }
        // throw exception on timeout
        if (timeout < 0) 
            throw new RuntimeException("Timed out waiting for agent to restart")
    }
    
    def invoke(params) {
        JSONArray res = new JSONArray()
        def cmd   = params.getOne('cmd')
        def bundle = params.getOne('bundle')
        def plugin = params.getOne('plugin')
        // iterate through all the group members, restarting 4.0 agents
        for (resource in viewedMembers) {
            def final aeid   = resource.entityId
            def rsltDescription
            try {
                log.info "Issuing ${cmd} command to agent with id ${aeid.id}"
                if (cmd == "restart") {
                    agentManager.restartAgent(user, aeid)
                } else if (cmd == "ping") {
                    agentManager.pingAgent(user, aeid)
                } else if (cmd == "upgrade") {
                    log.info "Upgrading agent with id ${aeid.id} to bundle ${bundle}"
                    agentManager.upgradeAgentAsync(user, aeid, bundle)
                } else if (cmd == "push plugin") {
                    log.info "Pushing plugin ${plugin} bundle to agent with id ${aeid.id}"
                    agentManager.transferAgentPluginAsync(user, aeid, plugin)
                }
                rsltDescription = "Successfully sent ${cmd} command to agent with id ${aeid.id}"
                log.info "Successfully sent ${cmd} command to agent with id ${aeid.id}"
            } catch (PermissionException p) {
            	rsltDescription = "Failed to send ${cmd} command to agent with id ${aeid.id}. Reason: Insufficient permissions"
            	log.info "Failed to send ${cmd} command to agent with id ${aeid.id}. Reason: ${p.message}"
            } catch (Exception e) {
                rsltDescription = "Failed to send ${cmd} command to agent with id ${aeid.id}. Reason: ${e.message}"
                log.error("Failed to send ${cmd} command to agent with id ${aeid.id}", e)
            }
            def val = [rid: aeid.toString(), result: rsltDescription] as JSONObject
            res.put(val)
        }
        JSONObject jsres = new JSONObject()
        jsres.put('results', res)
        jsres.put('command', cmd)
        render(inline:"/* ${jsres} */", 
               contentType:'json-comment-filtered')
    }
}
