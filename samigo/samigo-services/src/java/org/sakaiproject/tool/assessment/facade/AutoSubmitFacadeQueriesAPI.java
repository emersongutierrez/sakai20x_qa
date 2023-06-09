/*
 * Copyright (c) 2003-2022 The Apereo Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://opensource.org/licenses/ecl2
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.sakaiproject.tool.assessment.facade;

import java.util.Date;
import java.util.Map;
import java.util.Set;
import org.sakaiproject.tool.assessment.data.dao.assessment.PublishedSectionData;
import org.sakaiproject.tool.assessment.data.dao.grading.AssessmentGradingData;

/**
 * Queries for persisting a single attempt/submission and all related updates in a single transaction. This is important
 * because exceptions thrown in the autosubmit job can roll back the entire progress of the job. By processing
 * each attempt in a separate transaction, each successfully processed attempt will still be saved if the job aborts
 * and rolls back the main transaction.
 * @author plukasew
 */
public interface AutoSubmitFacadeQueriesAPI
{
	/**
	 * Persist updates to a single assessment attempt/submission to the database. This includes updating the attempt,
	 * the Gradebook integration, and the Samigo event log, as well as firing an event to trigger the email notification system.
	 * @param adata the data for this attempt/submission
	 * @param updateGrades if integration with Gradebook is a possibility
	 * @param agfq service for persisting the attempt
	 * @param assessment the assessment
	 * @param currentTime timestamp when the job started
	 * @param lastAgentId agent id from the previously processed attempt
	 * @param lastPublishedAssessmentId assessment id from the previously processed attempt
	 * @param sectionSetMap map of assessment id to assessment sections (aka parts)
	 * @return true if all processing succeeded
	 */
	public boolean processAttempt(AssessmentGradingData adata, boolean updateGrades, AssessmentGradingFacadeQueriesAPI agfq, PublishedAssessmentFacade assessment,
			Date currentTime, String lastAgentId, Long lastPublishedAssessmentId, Map<Long, Set<PublishedSectionData>> sectionSetMap);
}
