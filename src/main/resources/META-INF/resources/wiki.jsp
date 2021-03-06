<%@ include file="/init.jsp"%>

<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems='<%= dummyFactoryDisplayContext.getNavigationBarItems("Wiki") %>'
/>
	
<div class="container-fluid-1280">

	<aui:fieldset-group markupView="lexicon">	
		<aui:fieldset>
		
			<liferay-ui:success key="success" message="Wiki page / node created successfully" />
			<%@ include file="/command_select.jspf"%>
		
			<portlet:actionURL name="<%= LDFPortletKeys.WIKI %>" var="wikiEditURL">
				<portlet:param name="<%= LDFPortletKeys.MODE %>" value="<%=LDFPortletKeys.MODE_WIKI %>" />
				<portlet:param name="redirect" value="<%=portletURL.toString()%>" />
			</portlet:actionURL>			

			<%
			String numberOfnodesLabel = "Enter the number of wiki nodes you would like to create";
			String baseNodeNameLabel = "Enter the base name for the node";
			String groupIdLabel = "Chose site";
			String createContentsTypeLabel = "Select create type";
			
			String numberOfpagesLabel = "Enter the number of wiki pages you would like to create";
			String basePageNameLabel = "Enter the base name for the page";
			String baseContentNameLabel = "Enter the base ontent for the page";
			String baseSummaryNameLabel = "Enter the base summary for the page";
			String minorEditLabel = "Create this page as minor edit";			

					// Set Guest group ID for scope group ID
			final long guestGroupId = GroupLocalServiceUtil
					.getGroup(themeDisplay.getCompanyId(), GroupConstants.GUEST).getGroupId();
			List<Group> groups = GroupLocalServiceUtil.getGroups(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
			String defaultOption = "(None)";
			
			%>

			<aui:form action="<%= wikiEditURL %>" method="post" name="fm" >
				<aui:select name="createContentsType" label="<%= createContentsTypeLabel %>" >
					<aui:option selected="true" label="Wiki Node" value="<%= String.valueOf(LDFPortletKeys.W_NODE) %>" />
					<aui:option label="Wiki Page" value="<%= String.valueOf(LDFPortletKeys.W_PAGE) %>" />
				</aui:select>
							
				<aui:select name="groupId" label="<%= groupIdLabel %>" >
					<aui:option label="<%= defaultOption %>" value="<%= guestGroupId %>" />
					<%
					for (Group group : groups) {
						if (group.isSite()) {
					%>
							<aui:option label="<%= group.getDescriptiveName() %>" value="<%= group.getGroupId() %>"/>
					<%
						}
					}
					%>
				</aui:select>	
											
				<span id="<portlet:namespace />contentsType<%= String.valueOf(LDFPortletKeys.W_NODE) %>" class="<portlet:namespace />contentsTypeGroup" >
					<aui:input name="numberOfnodes" label="<%= numberOfnodesLabel %>" >
						<aui:validator name="digits" />
						<aui:validator name="min">1</aui:validator>
				        <aui:validator name="required">
			                function() {
		                        return (<%= String.valueOf(LDFPortletKeys.W_NODE) %> == AUI.$('#<portlet:namespace />createContentsType').val());
			                }
				        </aui:validator>				
					</aui:input>
					
					<aui:input name="baseNodeName" label="<%= baseNodeNameLabel %>" >
				        <aui:validator name="required">
			                function() {
		                        return (<%= String.valueOf(LDFPortletKeys.W_NODE) %> == AUI.$('#<portlet:namespace />createContentsType').val());
			                }
				        </aui:validator>				
					</aui:input>
			
				</span>
				<span id="<portlet:namespace />contentsType<%= String.valueOf(LDFPortletKeys.W_PAGE) %>" class="<portlet:namespace />contentsTypeGroup" style="display:none;">
					<%
						String nodesLabel = "Available nodes";
						String pagesLabel = "Available parent pages";
					%>
					
					<aui:select name="nodeId" label="<%= nodesLabel %>" >
						<aui:validator name="digits" />
						<aui:validator name="min">1</aui:validator>					
				        <aui:validator name="required">
			                function() {
		                        return (<%= String.valueOf(LDFPortletKeys.W_PAGE) %> == AUI.$('#<portlet:namespace />createContentsType').val());
			                }
				        </aui:validator>				
					</aui:select>	
									
					<aui:select name="resourcePrimKey" label="<%= pagesLabel %>" >
						<aui:option label="<%= defaultOption %>" value="0" />
					</aui:select>	
							
					<%
					WikiCommons wikiCommons = (WikiCommons)request.getAttribute(LDFPortletWebKeys.WIKI_COMMONS);
					Map<String, String> formats = wikiCommons.getFormats(locale);
					%>
									
					<aui:select changesContext="<%= true %>" name="format">
						<%
						for(Map.Entry<String, String> format : formats.entrySet()) {
						%>
							<aui:option label="<%= format.getValue() %>" value="<%= format.getKey() %>" />
						<%
						}
						%>
					</aui:select>			
																						
					<aui:input name="numberOfpages" label="<%= numberOfpagesLabel %>" >
						<aui:validator name="digits" />
						<aui:validator name="min">1</aui:validator>
				        <aui:validator name="required">
			                function() {
		                        return (<%= String.valueOf(LDFPortletKeys.W_PAGE) %> == AUI.$('#<portlet:namespace />createContentsType').val());
			                }
				        </aui:validator>				
					</aui:input>

					<aui:input name="basePageName" label="<%= basePageNameLabel %>" >
				        <aui:validator name="required">
			                function() {
		                        return (<%= String.valueOf(LDFPortletKeys.W_PAGE) %> == AUI.$('#<portlet:namespace />createContentsType').val());
			                }
				        </aui:validator>				
					</aui:input>		
					
					<aui:input name="baseContentName" label="<%= baseContentNameLabel %>" />								
					<aui:input name="baseSummaryName" label="<%= baseSummaryNameLabel %>" />	
					<aui:input name="minorEdit" type="toggle-switch" label="<%= minorEditLabel %>" value="<%= false %>"/>							
				</span>

				<aui:button-row>
					<aui:button type="submit" value="Run" cssClass="btn-lg btn-block btn-primary" id="processStart"/>
				</aui:button-row>	
			</aui:form>	
			
			<liferay-ui:upload-progress
				id="<%= progressId %>"
				message="creating..."
			/>	
				
		</aui:fieldset>	
	</aui:fieldset-group>
		
</div>

<script type="text/html" id="<portlet:namespace />node_options">
    <option value="<@= nodeId @>" selected="<@= selected @>"><@= name @></option>
</script>

<script type="text/html" id="<portlet:namespace />page_options">
    <option value="<@= resourcePrimKey @>" ><@= title @></option>
</script>

<aui:script use="aui-base, liferay-form">	
	
    // Manage GroupID list display
    var createContentsType = A.one('#<portlet:namespace />createContentsType');

	$('#<portlet:namespace />createContentsType').on(
	    'change',
	    function() {
	    	initialUpdate();
	    }
	); 
	
	// Initialize
	initialUpdate();
	
	// Initialize when a page rendered.
	function initialUpdate() {
    	//--------------------------------
    	// Contents Creation fields switch
    	//--------------------------------
   		var cmp_str = "<portlet:namespace />contentsType" + createContentsType.val();
    	$('.<portlet:namespace />contentsTypeGroup').each(function(index){
			$(this).toggle((cmp_str === $(this).attr("id")));
    	});
    	
		//Update thread list
		<portlet:namespace />nodesUpdate()
		.then(function() {
			<portlet:namespace />pagesUpdate();
		});	    
	}	
	
	// Generate dummy data
	$('#<portlet:namespace />processStart').on(
	    'click',
	    function() {
	    	event.preventDefault();
			<%= progressId %>.startProgress();
			submitForm(document.<portlet:namespace />fm);
	    }
	)
 

	
	// Group ID
	$('#<portlet:namespace />groupId').on(
	    'change load',
	    function() {
			//Update thread list
			<portlet:namespace />nodesUpdate()
			.then(function() {
				<portlet:namespace />pagesUpdate();
			});	    
	    }
	)
		
	// Nodes update
	function <portlet:namespace />nodesUpdate() {
		var defer = $.Deferred();
			
		var groupId = A.one('#<portlet:namespace />groupId').val();
		
		Liferay.Service(
			'/wiki.wikinode/get-nodes',
			{
				groupId: groupId,
				start: -1,
				end: -1,
			},
			function(data) {
				//Load Template
				var tmpl = _.template($('#<portlet:namespace />node_options').html());
	            var listAll = tmpl({
	                nodeId:"0",
	                name:"(None)",
	                selected:"true"
	            });
				
				_.map(data,function(n) {
					listAll += 
					tmpl(
					  {
						nodeId:(n.nodeId) ? _.escape(n.nodeId) : "",
						name:(n.name) ? _.escape(n.name) : "",
						selected:"false"
					  }
					);
				});
				var catObj = $('#<portlet:namespace />nodeId');
				catObj.empty();
				catObj.append(listAll);
				defer.resolve();	
			}
		);	
		return defer.promise();
	}	
	
	// Node ID
	$('#<portlet:namespace />nodeId').on(
	    'change',
	    function() {
	    	<portlet:namespace />pagesUpdate();
	    }
	)
		
	// Pages update
	function <portlet:namespace />pagesUpdate() {
		var defer = $.Deferred();

		var groupId = A.one('#<portlet:namespace />groupId').val();
		var nodeId = A.one('#<portlet:namespace />nodeId').val();

		Liferay.Service(
			'/wiki.wikipage/get-pages',
			{
				groupId: groupId,
				nodeId: nodeId,
				head : true,
				status: <%= String.valueOf(WorkflowConstants.STATUS_APPROVED)  %>,
				start: -1,
				end: -1,
			    "+obc":"com.liferay.wiki.util.comparator.PageTitleComparator" 
			},
			function(data) {
				//Load Template
				var tmpl = _.template($('#<portlet:namespace />page_options').html());
	            var listAll = tmpl({
	                resourcePrimKey:"0",
	                title:"(None)"
	            });
				
				_.map(data,function(n) {
					listAll += 
					tmpl(
					  {
						resourcePrimKey:(n.resourcePrimKey) ? _.escape(n.resourcePrimKey) : "",
						title:(n.title) ? _.escape(n.title) : ""
					  }
					);
				});
				var catObj = $('#<portlet:namespace />resourcePrimKey');
				catObj.empty();
				catObj.append(listAll);
				defer.resolve();
			}
		);	
		return defer.promise();
	}
	
</aui:script>
