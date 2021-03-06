<%@ include file="/init.jsp"%>

<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems='<%= dummyFactoryDisplayContext.getNavigationBarItems("Organization") %>'
/>
	
<div class="container-fluid-1280">

	<aui:fieldset-group markupView="lexicon">	
		<aui:fieldset>
		
			<liferay-ui:success key="success" message="Organizations created successfully" />
			<%@ include file="/command_select.jspf"%>
		
			<portlet:actionURL name="<%= LDFPortletKeys.ORGANIZAION %>" var="organizationEditURL">
				<portlet:param name="redirect" value="<%=portletURL.toString()%>" />
			</portlet:actionURL>	
				
			<div class="entry-title form-group">
				<h1>Create organizations&nbsp;&nbsp;
					<a aria-expanded="false" class="collapse-icon collapsed icon-question-sign" data-toggle="collapse" href="#navPillsCollapse0">
					</a>
				</h1>
			</div>
			<div class="collapsed collapse" id="navPillsCollapse0" aria-expanded="false" >
				<blockquote class="blockquote-info">
				    <small>Example</small>
					<p>If you enter the values <code>3</code> and "org" the portlet will create three organizations: <code>org1</code>, <code>org2</code>, and <code>org3</code>.<p>
				</blockquote>
				<ul>
					<li>You must be signed in as an administrator in order to create organizations</li>
					<li>The counter always starts at <code>1</code></li>
					<li>The organization type is <code>Organization</code></li>
				</ul>
			</div>

			<%
			String numberOfOrganizationsLabel = "Enter the number of organizations you would like to create";
			String baseOrganizationNameLabel = "Enter the base name for the organizations";
			String parentOrganizationIdLabel = "Select the parent organization";
			String organizationSiteCreateLabel = "Creating organization site";
			%>

			<aui:form action="<%= organizationEditURL %>" method="post" name="fm" >
				<aui:input name="<%= Constants.CMD %>" type="hidden" />
				<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
				<aui:input name="numberOfOrganizations" label="<%= numberOfOrganizationsLabel %>" >
					<aui:validator name="digits" />
					<aui:validator name="min">1</aui:validator>
					<aui:validator name="required" />				
				</aui:input>
				<aui:input name="baseOrganizationName" label="<%= baseOrganizationNameLabel %>" >
					<aui:validator name="required" />				
				</aui:input>
		
			   <%
					//Organization
					List<Organization> organizations = OrganizationLocalServiceUtil.getOrganizations(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
					String defaultOption = "(None)";
				%>
				<aui:a href="#inputOptions" cssClass="collapse-icon collapsed icon-angle-down" title="Option" aria-expanded="false" data-toggle="collapse" >&nbsp;&nbsp;option</aui:a>
				<div class="collapsed collapse" id="inputOptions" aria-expanded="false" >
					<div class="row">
						<aui:fieldset cssClass="col-md-6">
							<aui:select name="parentOrganizationId" label="<%= parentOrganizationIdLabel %>" >
								<aui:option label="<%= defaultOption %>" value="<%= OrganizationConstants.DEFAULT_PARENT_ORGANIZATION_ID %>" />
								<%
								for (Organization organization : organizations) {
								%>
									<aui:option label="<%= organization.getName() %>" value="<%= organization.getOrganizationId() %>"/>
								<%
								}
								%>
							</aui:select>						
 						</aui:fieldset>
						<aui:fieldset cssClass="col-md-6">
							<aui:input type="toggle-switch" name="organizationSiteCreate" label="<%= organizationSiteCreateLabel %>" value="false" />
						</aui:fieldset> 						
					</div>
				</div>	
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

<aui:script use="aui-base">
	var processStart = A.one('#<portlet:namespace />processStart');
	
	processStart.on(
	    'click',
	    function() {
	    	event.preventDefault();
			<%= progressId %>.startProgress();
			submitForm(document.<portlet:namespace />fm);
	    }
	);
</aui:script>