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
		<h:form id="locale_form">
<h:outputText value="#{Portal.latestJQuery}" escape="false"/>
		<script src="/sakai-user-tool-prefs/js/prefs.js">// </script>
		<script src="/library/js/spinner.js"></script>

				<%-- Set current value for template --%> 
				<c:set var="cTemplate" value = "locale" scope="session"/>
				
				<%@ include file="toolbar.jspf"%>

				<div class="page-header">
					<h1><h:outputText value="#{msgs.prefs_lang_title}"/></h1>
				</div>

				<h:messages rendered="#{!empty facesContext.maximumSeverity}" />

				<t:div rendered="#{UserPrefsTool.locUpdated}">
					<jsp:include page="prefUpdatedMsg.jsp"/>
				</t:div>

				<p class="instruction"><h:outputText value="#{msgs.locale_msg} "/> <h:outputText value="#{UserPrefsTool.selectedLocaleName}"  styleClass="highlight" style="font-weight:bold !important;"/></p>
				
    			 <h:selectOneListbox 
                      value="#{UserPrefsTool.selectedLocaleString}"
                      size="20"
                      styleClass="multiLine">
				    <f:selectItems value="#{UserPrefsTool.prefLocales}" />
				 </h:selectOneListbox>
			    <div class="act">
				    <h:commandButton accesskey="s" id="submit" styleClass="active formButton" value="#{msgs.update_pref}" action="#{UserPrefsTool.processActionLocSave}" onclick="SPNR.disableControlsAndSpin( this, null );" />
				    <h:commandButton accesskey="x" id="cancel"  styleClass="formButton" value="#{msgs.cancel_pref}" action="#{UserPrefsTool.processActionLocCancel}" onclick="SPNR.disableControlsAndSpin( this, null );" />
			    </div>
		 </h:form>
	</sakai:view_content>
	</sakai:view_container>
</f:view>
