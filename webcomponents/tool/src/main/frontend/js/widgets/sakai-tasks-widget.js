import { html } from "../assets/lit-element/lit-element.js";
import { ifDefined } from "../assets/lit-html/directives/if-defined.js";
import { SakaiDashboardWidget } from './sakai-dashboard-widget.js';
import '../tasks/sakai-tasks.js';

export class SakaiTasksWidget extends SakaiDashboardWidget {

  constructor() {

    super();

    this.widgetId = "tasks";
  }

  content() {

    return html`
      <sakai-tasks
        user-id="${ifDefined(this.userId ? this.userId : "")}"
        site-id="${ifDefined(this.siteId ? this.siteId : "")}"
      >
      </sakai-tasks>
    `;
  }
}

if (!customElements.get("sakai-tasks-widget")) {
  customElements.define("sakai-tasks-widget", SakaiTasksWidget);
}
