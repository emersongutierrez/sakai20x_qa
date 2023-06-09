<%-- HTML JSF tag libary --%>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%-- Core JSF tag library --%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%-- Sakai JSF tag library --%>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai" %>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="t"%>
<%-- Core JSTL tag library --%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<f:view>
	<sakai:view_container title="#{msgs.prefs_title}">
	<sakai:view_content>
		<h:form id="timezone_form">
<h:outputText value="#{Portal.latestJQuery}" escape="false"/>
		<script src="/sakai-user-tool-prefs/js/prefs.js">// </script>
		<script src="/library/js/spinner.js"></script>

				<%-- Set current value for template --%> 
				<c:set var="cTemplate" value = "timezone" scope = "session" />
				<%@ include file="toolbar.jspf"%>

				<div class="page-header">
					<h1><h:outputText value="#{msgs.prefs_timezone_title}"/></h1>
				</div>

				<h:messages rendered="#{!empty facesContext.maximumSeverity}" />
				<t:div rendered="#{UserPrefsTool.tzUpdated}">
					<jsp:include page="prefUpdatedMsg.jsp"/>
				</t:div>

				<p class="instruction">
				<h:outputFormat value="#{msgs.time_inst}">
					<f:param value="#{UserPrefsTool.serviceName}"/>
					<f:param value="#{UserPrefsTool.selectedTimeZone}"/>
				</h:outputFormat>
				</p>
					
    			 <h:selectOneListbox 
                      value="#{UserPrefsTool.selectedTimeZone}"
                      size="20"
                      styleClass="multiLine">
				    <f:selectItems value="#{UserPrefsTool.prefTimeZones}" />
				 </h:selectOneListbox>

			    <div class="act">
					<h:commandButton accesskey="s" id="submit" styleClass="active formButton" value="#{msgs.update_pref}" action="#{UserPrefsTool.processActionTzSave}" onclick="SPNR.disableControlsAndSpin( this, null );" />
					<h:commandButton accesskey="x" id="cancel" styleClass="formButton" value="#{msgs.cancel_pref}" action="#{UserPrefsTool.processActionTzCancel}" onclick="SPNR.disableControlsAndSpin( this, null );" />
			    </div>
		 </h:form>
	</sakai:view_content>
	</sakai:view_container>
</f:view>
