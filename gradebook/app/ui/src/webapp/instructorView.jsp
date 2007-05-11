<link href="dhtmlpopup/dhtmlPopup.css" rel="stylesheet" type="text/css" />
<script src="dhtmlpopup/dhtmlPopup.js" type="text/javascript"></script>
<script src="js/dynamicSizeCheck.js" type="text/javascript"></script>

<f:view>
	<div class="portletBody">
	  <h:form id="gbForm">

		<sakai:flowState bean="#{instructorViewBean}" />
		
		<t:aliasBean alias="#{bean}" value="#{instructorViewBean}">
			<%@include file="/inc/appMenu.jspf" %>
		</t:aliasBean>

		<t:aliasBean alias="#{bean}" value="#{instructorViewBean}">
			<%@include file="/inc/breadcrumbInstructor.jspf" %>
		</t:aliasBean>

		<h:panelGrid columns="2" width="99%" columnClasses="bogus,right">
			<h:panelGroup>
				<f:verbatim><h3></f:verbatim>
					<h:outputText value="#{msgs.inst_view_student_summary}" />
				<f:verbatim></h3></f:verbatim>
			</h:panelGroup>
			<h:commandLink action="studentView" style="text-align: right;">
				<h:outputFormat value="#{msgs.inst_view_students_grades}">
					<f:param value="#{instructorViewBean.userDisplayName}" />
				</h:outputFormat>
				<f:param name="studentUidToView" value="#{instructorViewBean.studentUid}" />
				<f:param name="instViewReturnToPage" value="#{instructorViewBean.returnToPage}" />
				<f:param name="instViewAssignmentId" value="#{instructorViewBean.assignmentId}" />
			</h:commandLink>
		</h:panelGrid>
		
		
		<div class="nav indnt3 gbSection">
			<h:commandButton
				disabled="#{instructorViewBean.first}"
				actionListener="#{instructorViewBean.processStudentUidChange}"
				value="#{msgs.inst_view_prev}"
				title="#{instructorViewBean.previousStudent.user.displayName}"
				accesskey="p"
				tabindex="4" >
					<f:param name="studentUid" value="#{instructorViewBean.previousStudent.user.userUid}"/>
				</h:commandButton>
			
			<h:commandButton
				action="#{instructorViewBean.processCancel}"
				value="#{instructorViewBean.returnToPageName}"
				accesskey="l"
				tabindex="6"/>
			
			<h:commandButton
				disabled="#{instructorViewBean.last}"
				actionListener="#{instructorViewBean.processStudentUidChange}"
				value="#{msgs.inst_view_next}"
				title="#{instructorViewBean.nextStudent.user.displayName}"
				accesskey="n"
				tabindex="5">
					<f:param name="studentUid" value="#{instructorViewBean.nextStudent.user.userUid}"/>
			</h:commandButton>
		</div>
		
		<h:panelGrid cellpadding="0" cellspacing="0"
			columns="2"
			columnClasses="itemName"
			styleClass="itemSummary gbSection">	
			<h:outputText value="#{msgs.inst_view_name}" />
			<h:outputText value="#{instructorViewBean.userDisplayName}" />
			
			<h:outputText value="#{msgs.inst_view_email}" />
			<h:outputText value="#{instructorViewBean.studentEmailAddress}" />
			
			<h:outputText value="#{msgs.inst_view_id}" />
			<h:outputText value="#{instructorViewBean.currentStudent.user.displayId}" />
			
			<h:outputText value="#{msgs.inst_view_sections}"/>
			<h:outputText value="#{instructorViewBean.studentSections}"/>
		</h:panelGrid>
		
		<hr/>
		
		<h:panelGrid cellpadding="0" cellspacing="0"
			columns="2"
			columnClasses="itemName"
			styleClass="itemSummary gbSection">	
			<h:outputText value="#{msgs.inst_view_cum_score}" />
			<h:panelGroup>
				<h:outputFormat value=" #{msgs.inst_view_cum_score_details}" rendered="#{instructorViewBean.percent != null}">
					<f:param value="#{instructorViewBean.percent}" />
				</h:outputFormat>
			</h:panelGroup>
			
			<h:outputText value="#{msgs.inst_view_course_grade}" />
			<h:panelGroup>
				<h:outputText value="#{instructorViewBean.courseGrade}" />	
			</h:panelGroup>
		</h:panelGrid>
		
		<h4>
			<h:outputText value="#{msgs.inst_view_grading_table}" />
		</h4>
		
		<%@include file="/inc/globalMessages.jspf"%>
		
		<gbx:gradebookItemTable cellpadding="0" cellspacing="0"
				value="#{instructorViewBean.gradebookItems}"
				var="row"
        sortColumn="#{instructorViewBean.sortColumn}"
				sortAscending="#{instructorViewBean.sortAscending}"
				columnClasses="attach,left,center,center,center,center,center,center,center,external"
				rowClasses="#{instructorViewBean.rowStyles}"
				headerClasses="attach,left,center,center,center,center,center,center,center comments,bogus"
				styleClass="listHier narrowerTable"
				expanded="true"
				rowIndexVar="rowIndex">
				
				<h:column id="_toggle" rendered="#{instructorViewBean.categoriesEnabled}">
					<f:facet name="header">
						<h:outputText value="" />
					</f:facet>
				</h:column>
				
				<h:column id="_title">
					<f:facet name="header">
						<t:commandSortHeader columnName="name" immediate="true" arrow="true">
							<h:outputText value="#{msgs.inst_view_title}"/>
							<h:outputText value="#{msgs.inst_view_footnote_symbol1}" />
						</t:commandSortHeader>
					</f:facet>
					
					<h:panelGroup rendered="#{row.assignment}">
						<h:commandLink action="#{instructorViewBean.navigateToAssignmentDetails}" rendered="#{row.associatedAssignment.released}">
							<h:outputText value="#{row.associatedAssignment.name}" />
							<f:param name="assignmentId" value="#{row.associatedAssignment.id}"/>
						</h:commandLink>
						<h:panelGroup rendered="#{!row.associatedAssignment.released}" styleClass="inactive" >
							<h:commandLink action="#{instructorViewBean.navigateToAssignmentDetails}" >
								<h:outputText value="#{row.associatedAssignment.name}"/>
								<f:param name="assignmentId" value="#{row.associatedAssignment.id}"/>
							</h:commandLink>
						</h:panelGroup>
					</h:panelGroup>
					
					<h:outputText value="#{row.name}" styleClass="categoryHeading" rendered="#{row.category}"/>
				</h:column>
				
				<h:column>
					<f:facet name="header">
						<t:commandSortHeader columnName="dueDate" immediate="true" arrow="true">
							<h:outputText value="#{msgs.inst_view_due_date}"/>
						</t:commandSortHeader>
					</f:facet>

					<h:outputText value="#{row.associatedAssignment.dueDate}" rendered="#{row.assignment && row.associatedAssignment.dueDate != null}">
						<gbx:convertDateTime />
					</h:outputText>
					<h:outputText value="#{msgs.score_null_placeholder}" rendered="#{row.assignment && row.associatedAssignment.dueDate == null}"/>
				</h:column>
				    
        <h:column rendered="#{instructorViewBean.weightingEnabled}">
					<f:facet name="header">
			    	<t:commandSortHeader columnName="weight" immediate="true" arrow="true">
							<h:outputText value="#{msgs.inst_view_weight}"/>
			      </t:commandSortHeader>
			    </f:facet>
	
					<h:outputText value="#{row.weight}" rendered="#{row.category}">
						<f:convertNumber type="percent" maxFractionDigits="2" />
					</h:outputText>
				</h:column>
				
				<h:column>
					<f:facet name="header">
						<h:outputText value="#{msgs.inst_view_log}" styleClass="tier0"/>
					</f:facet>
					<h:outputLink value="#"
					rendered="#{row.assignment && not empty row.eventRows}"
					onclick="javascript:dhtmlPopupToggle('#{rowIndex}', event);return false;">
					<h:graphicImage value="images/log.png" alt="#{msgs.inst_view_log_alt}"/>
				</h:outputLink>
				</h:column>
				
				<h:column>
					<f:facet name="header">
						<t:commandSortHeader columnName="pointsEarned" immediate="true" arrow="true">
							<h:outputText value="#{msgs.inst_view_grade}" rendered="#{!instructorViewBean.gradeEntryByPercent}" />
							<h:outputText value="#{msgs.inst_view_grade_percent}" rendered="#{instructorViewBean.gradeEntryByPercent}" />
							<h:outputText value="#{msgs.inst_view_footnote_symbol2}" />
						</t:commandSortHeader>
					</f:facet>

						<h:panelGroup rendered="#{row.assignment}" style="white-space:nowrap;">
							<h:outputText value="#{msgs.inst_view_not_counted_open}" rendered="#{!row.associatedAssignment.counted}" />
							
							<h:inputText id="Score" value="#{row.score}" size="4" 
								 rendered="#{!row.associatedAssignment.externallyMaintained}"
								 style="text-align:right;" onkeypress="return submitOnEnter(event, 'gbForm:saveButton');">
								<f:converter converterId="org.sakaiproject.gradebook.jsf.converter.NONTRAILING_DOUBLE" />
								<f:validateDoubleRange minimum="0"/>
								<f:validator validatorId="org.sakaiproject.gradebook.jsf.validator.ASSIGNMENT_GRADE"/>
							</h:inputText>
							
							<h:outputText value="#{row.score}" rendered="#{row.associatedAssignment.externallyMaintained}">
								<f:converter converterId="org.sakaiproject.gradebook.jsf.converter.POINTS" />
							</h:outputText>
							
							<h:outputText value="#{msgs.inst_view_not_counted_close}" rendered="#{!row.associatedAssignment.counted}" />
						</h:panelGroup>
						
						<h:outputText value="#{row}" escape="false" rendered="#{row.category}">
							<f:converter converterId="org.sakaiproject.gradebook.jsf.converter.CLASS_AVG_CONVERTER"/>
						</h:outputText>
        </h:column>
        
        <h:column rendered="#{instructorViewBean.gradeEntryByPoints}">
        	<f:facet name="header" >
        		<t:commandSortHeader columnName="itemValue" immediate="true" arrow="true" rendered="#{instructorViewBean.gradeEntryByPoints}">
							<h:outputText value="#{msgs.inst_view_item_value}"/>
						</t:commandSortHeader>
        	</f:facet>
        	
        	<h:outputText value="#{row.associatedAssignment.pointsPossible}" rendered="#{row.assignment}">
        		<f:converter converterId="org.sakaiproject.gradebook.jsf.converter.POINTS"/>
        	</h:outputText>
        </h:column>
        
        <h:column rendered="#{instructorViewBean.gradeEntryByPercent}">
        	<f:facet name="header" >
						<h:outputText value="#{msgs.inst_view_item_value}" rendered="#{!instructorViewBean.gradeEntryByPoints}" />
        	</f:facet>
        	
        	<h:outputText value="#{msgs.inst_view_percent_value}" rendered="#{row.assignment}" />
        </h:column>
	    
		    <h:column>
	        <f:facet name="header">
	        	<h:outputText value="#{msgs.inst_view_comments}"/>
	        </f:facet>
	        <h:message for="Score" styleClass="validationEmbedded gbMessageAdjustForContent"/>
	        <h:outputText value="#{row.commentText}" rendered="#{row.assignment && row.commentText != null}" />
		    </h:column>
		    
		    <h:column rendered="#{instructorViewBean.anyExternallyMaintained}">
		       <h:outputText value="#{row.associatedAssignment.externalAppName}" rendered="#{row.assignment}" />
		    </h:column>
		  </gbx:gradebookItemTable>
		  
		  <t:aliasBean alias="#{bean}" value="#{instructorViewBean}">
			 <%@include file="/inc/gradingEventLogsInstView.jspf"%>
		  </t:aliasBean>
		
		
			<div class="act">
				<h:commandButton
					id="saveButton"
					styleClass="active"
					value="#{msgs.inst_view_save}"
					action="#{instructorViewBean.processUpdateScores}"
					accesskey="s"
					tabindex="9998"
					title="#{msgs.inst_view_save}"/>
				<h:commandButton
					value="#{msgs.inst_view_clear}"
					action=""
					immediate="true"
					accesskey="c"
					tabindex="9999"
					title="#{msgs.inst_view_clear}"/>
			</div>
				
			<h:panelGrid styleClass="instruction gbSection" cellpadding="0" cellspacing="0" columns="1">
				<h:outputText value="#{msgs.inst_view_legend_title}" />
				<h:panelGroup>
					<h:outputText value="#{msgs.inst_view_footnote_symbol1}" />
					<h:outputText value="#{msgs.inst_view_footnote_legend1}" />
				</h:panelGroup>
				<h:panelGroup>
					<h:outputText value="#{msgs.inst_view_footnote_symbol2}" />
					<h:outputText value="#{msgs.inst_view_footnote_legend2}" />
				</h:panelGroup>
			</h:panelGrid>

	  </h:form>
	</div>
</f:view>
