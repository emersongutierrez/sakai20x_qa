/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2005, 2006, 2007, 2008 The Sakai Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.opensource.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **********************************************************************************/
package org.sakaiproject.tool.section.facade.sakai;

import lombok.extern.slf4j.Slf4j;

import org.sakaiproject.authz.api.AuthzGroupService;
import org.sakaiproject.authz.api.SecurityService;
import org.sakaiproject.section.api.SectionAwareness;
import org.sakaiproject.section.api.facade.manager.Authz;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.tool.section.jsf.JsfUtil;
import org.sakaiproject.user.api.User;
import org.sakaiproject.user.cover.UserDirectoryService;

/**
 * Uses Sakai's SecurityService to determine the current user's site role, or
 * consults the CourseSection membership to determine section role.
 * 
 * @author <a href="mailto:jholtzman@berkeley.edu">Josh Holtzman</a>
 *
 */
@Slf4j
public class AuthzSakaiImpl implements Authz {

	private AuthzGroupService authzGroupService;

	protected SecurityService securityService;

	public void setAuthzGroupService(AuthzGroupService authzGroupService) {
		this.authzGroupService = authzGroupService;
	}

	public void setSecurityService(SecurityService securityService) {
		this.securityService = securityService;
	}

	/**
	 * The user must have site.upd to update sections in the Section Info tool.
	 */
	public boolean isSectionManagementAllowed(String userUid, String siteContext) {
		User sakaiUser = UserDirectoryService.getCurrentUser();
		String siteRef = SiteService.siteReference(siteContext);
		boolean canUpdateSite = securityService.unlock(sakaiUser, SiteService.SECURE_UPDATE_SITE, siteRef);
		
		return canUpdateSite;
	}

	/**
	 * The user must have site.upd to update section options in the Section Info tool.
	 */
	public boolean isSectionOptionsManagementAllowed(String userUid, String siteContext) {
		return isSectionManagementAllowed(userUid, siteContext);
	}

	/**
	 * The user must have site.upd to update TA assignments in the Section Info
	 * tool, even though the framework doesn't require this (it would accept site.upd.grp.mbrshp).
	 */
	public boolean isSectionTaManagementAllowed(String userUid, String siteContext) {
		return isSectionManagementAllowed(userUid, siteContext);
	}

	/**
	 * The user must have either site.upd or site.upd.grp.mbrshp to update
	 * section enrollments in the Section Info tool.
	 */
	public boolean isSectionEnrollmentMangementAllowed(String userUid, String siteContext) {
		User sakaiUser = UserDirectoryService.getCurrentUser();
		String siteRef = SiteService.siteReference(siteContext);
		boolean canUpdateSite = securityService.unlock(sakaiUser, SiteService.SECURE_UPDATE_SITE, siteRef);
		boolean canUpdateGroups = securityService.unlock(sakaiUser, SiteService.SECURE_UPDATE_GROUP_MEMBERSHIP, siteRef);
		
		return canUpdateSite || canUpdateGroups;
	}

	/**
	 * The user must have access to the student marker function (section.role.student)
	 * to view their own section enrollments.
	 */
	public boolean isViewOwnSectionsAllowed(String userUid, String siteContext) {
		User sakaiUser = UserDirectoryService.getCurrentUser();
		String siteRef = SiteService.siteReference(siteContext);
		boolean isStudent = securityService.unlock(sakaiUser, SectionAwareness.STUDENT_MARKER, siteRef);
		
		return isStudent;
	}

	/**
	 * Even if a TA can't make changes to the sections or their enrollments,
	 * they can always view the sections and their enrollments.
	 */
	public boolean isViewAllSectionsAllowed(String userUid, String siteContext) {
		User sakaiUser = UserDirectoryService.getCurrentUser();
		String siteRef = SiteService.siteReference(siteContext);
		 return securityService.unlock(sakaiUser, SiteService.SECURE_UPDATE_SITE, siteRef) ||
				securityService.unlock(sakaiUser, SiteService.SECURE_UPDATE_GROUP_MEMBERSHIP, siteRef) ||
				securityService.unlock(sakaiUser, SectionAwareness.TA_MARKER, siteRef);
	}

	public boolean isSectionAssignable(String userUid, String siteContext) {
		return ! isSectionManagementAllowed(userUid, siteContext);
	}

	public String getRoleDescription(String userUid, String siteContext) {
		String siteRef = SiteService.siteReference(siteContext);
		String role = authzGroupService.getUserRole(userUid, siteRef);
		if(log.isDebugEnabled()) log.debug("User " + userUid + " has role " + role + " in site " + siteContext);
		if ((role == null) && (isSuperUser())) {
			// Is this a superuser?
			return JsfUtil.getLocalizedMessage("admin_role");
		}
		return role;
	}
	public boolean isSuperUser() {
		return securityService.isSuperUser();
	}

}
