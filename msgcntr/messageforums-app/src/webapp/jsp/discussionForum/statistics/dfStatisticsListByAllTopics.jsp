<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai" %>
<%@ taglib uri="http://sakaiproject.org/jsf/messageforums" prefix="mf" %>
<jsp:useBean id="msgs" class="org.sakaiproject.util.ResourceLoader" scope="session">
	<jsp:setProperty name="msgs" property="baseName" value="org.sakaiproject.api.app.messagecenter.bundle.Messages"/>	
</jsp:useBean>
<f:view>
  <sakai:view >
  	<h:form id="dfStatisticsForm" rendered="#{ForumTool.instructor}">
<!-- discussionForum/statistics/dfStatisticsList.jsp-->
       		<script>includeLatestJQuery("msgcntr");</script>
       		<script src="/messageforums-tool/js/sak-10625.js"></script>
			<script>
				$(document).ready(function() {
					var menuLink = $('#forumsStatisticsMenuLink');
					var menuLinkSpan = menuLink.closest('span');
					menuLinkSpan.addClass('current');
					menuLinkSpan.html(menuLink.text());
				});
			</script>

			<%@ include file="/jsp/discussionForum/menu/forumsMenu.jsp" %>
  		<h:panelGrid columns="2" width="100%" styleClass="navPanel  specialLink">
          <h:panelGroup>
			  <div class="page-header">
			 	<f:verbatim><h1></f:verbatim>
				  <h:commandLink action="#{ForumTool.processActionHome}" value="#{msgs.cdfm_message_forums}" title=" #{msgs.cdfm_message_forums}"
						rendered="#{ForumTool.messagesandForums}" />
				  <h:commandLink action="#{ForumTool.processActionHome}" value="#{msgs.cdfm_discussions}" title=" #{msgs.cdfm_discussions}"
						rendered="#{ForumTool.forumsTool}" />
				  <h:outputText value=" " />
				  <h:outputText value=" / " /><h:outputText value=" " />
				  <h:outputText value="#{msgs.stat_list}" />
				<f:verbatim></h1></f:verbatim>
			  </div>
          </h:panelGroup>
          <h:panelGroup styleClass="itemNav specialLink">        
          	<h:commandLink action="#{ForumTool.processActionStatistics}" value="#{msgs.cdfm_statistics} #{msgs.stat_byUser}" title="#{msgs.cdfm_statistics} #{msgs.stat_byUser}"/>
			<h:outputText value=" #{msgs.cdfm_toolbar_separator} " />
			<h:outputText value="#{msgs.cdfm_statistics} #{msgs.stat_byTopic}" style="padding-right: 5px;"/>
            <h:commandLink action="#{mfStatisticsBean.processExportDataTableByTopic}" value="#{msgs.stat_explort_table}" title="#{msgs.stat_explort_table}" />
            </h:panelGroup>
        </h:panelGrid>
  	
  	
      <div class="table">
  		<h:dataTable styleClass="table table-hover table-striped table-bordered lines nolines" id="members" value="#{mfStatisticsBean.allTopicStatistics}" var="stat" rendered="true"
   	 		columnClasses="specialLink,specialLink,bogus,bogus,bogus" cellpadding="0" cellspacing="0">
  			<h:column>
  				<f:facet name="header">
  					<h:commandLink action="#{mfStatisticsBean.toggleAllTopicsForumTitleSort}" title="#{msgs.stat_forum_title}">
					   	<h:outputText value="#{msgs.stat_forum_title}" />
						<h:graphicImage value="/images/sortascending.gif" rendered="#{mfStatisticsBean.allTopicsForumTitleSort && mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_forum_title}"/>
						<h:graphicImage value="/images/sortdescending.gif" rendered="#{mfStatisticsBean.allTopicsForumTitleSort && !mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_forum_title}"/>
					</h:commandLink>
  				</f:facet>
				<h:commandLink action="#{mfStatisticsBean.processActionStatisticsByTopic}" immediate="true">
  				    <f:param value="" name="topicId"/>
  				    <f:param value="#{stat.forumId}" name="forumId"/>
  				    <h:outputText value="#{stat.forumTitle}" />
	          	</h:commandLink>  
			</h:column>
  			<h:column>
  				<f:facet name="header">
  					<h:commandLink action="#{mfStatisticsBean.toggleAllTopicsTopicTitleSort}" title="#{msgs.stat_topic_title}">
					   	<h:outputText value="#{msgs.stat_topic_title}" />
						<h:graphicImage value="/images/sortascending.gif" rendered="#{mfStatisticsBean.allTopicsTopicTitleSort && mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_topic_title}"/>
						<h:graphicImage value="/images/sortdescending.gif" rendered="#{mfStatisticsBean.allTopicsTopicTitleSort && !mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_topic_title}"/>
					</h:commandLink>
  				</f:facet>
  				<h:commandLink action="#{mfStatisticsBean.processActionStatisticsByTopic}" immediate="true">
  				    <f:param value="#{stat.topicId}" name="topicId"/>
  				    <f:param value="#{stat.forumId}" name="forumId"/>
  				    <h:outputText value="#{stat.topicTitle}" />
	          	</h:commandLink>  				
  			</h:column>
  			<h:column>
  				<f:facet name="header">
  					<h:commandLink action="#{mfStatisticsBean.toggleAllTopicsForumDateSort}" title="#{msgs.stat_forum_date}">
					   	<h:outputText value="#{msgs.stat_forum_date}" />
						<h:graphicImage value="/images/sortascending.gif" rendered="#{mfStatisticsBean.allTopicsTopicDateSort && mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_forum_date}"/>
						<h:graphicImage value="/images/sortdescending.gif" rendered="#{mfStatisticsBean.allTopicsTopicDateSort && !mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_forum_date}"/>
					</h:commandLink>
  				</f:facet>
  				<h:outputText value="#{stat.topicDate}">
  					<f:convertDateTime pattern="#{msgs.date_format}" timeZone="#{ForumTool.userTimeZone}" locale="#{ForumTool.userLocale}"/>
  				</h:outputText>
  			</h:column>
  			<h:column>
  				<f:facet name="header">
  					<h:commandLink action="#{mfStatisticsBean.toggleAllTopicsTopicTotalMessagesSort}" title="#{msgs.stat_totalMessages}">
					   	<h:outputText value="#{msgs.stat_totalMessages}" />
						<h:graphicImage value="/images/sortascending.gif" rendered="#{mfStatisticsBean.allTopicsTopicTotalMessagesSort && mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_authored}"/>
						<h:graphicImage value="/images/sortdescending.gif" rendered="#{mfStatisticsBean.allTopicsTopicTotalMessagesSort && !mfStatisticsBean.ascendingForAllTopics}" alt="#{msgs.stat_authored}"/>
					</h:commandLink>
  				</f:facet>
  				<h:outputText value="#{stat.totalTopicMessages}" />
  			</h:column>  			
  		</h:dataTable>
      </div>
  
  	</h:form>
  </sakai:view>
</f:view>
