/*
 * Special care was taken to ensure the ability to place multiple comments
 * tools on one page.  Please keep this in mind when changing this code.
 */

var commentItemToReload = null;
var deleteDialogCommentUrl = null;
var originalDeleteDialogText = null;
var noEditor = true;
var userAgent = navigator.userAgent;
var ckEditor = false;
var commentsToLoad = 0;

var LSNGRD = LSNGRD || {};

LSNGRD.childClass = ".uuidBox";
LSNGRD.type = "comment";

$(function() {
	noEditor = ($(".using-editor").size() === 0);
	if (!noEditor)
		ckEditor = true;

	$(".evolved-box").hide();
	$(".submitButton").hide().val(msg("simplepage.save_message"));
	$(".cancelButton").hide().val(msg("simplepage.cancel_message"));
	
	$(".cancelButton").click(function() {
		switchEditors($(this), false);
		return false;
	});
	
	$.ajaxSetup ({
		cache: false
	});
	
	commentsToLoad = $(".replaceWithComments").size();
	$(".replaceWithComments").each(function(index) {
		var pageToRequest = $(this).parent().parent().children(".commentsBlock").attr("href");
		// remove  pda/SITEID/. We don't want the portal to hack on this
		//pageToRequest = pageToRequest.replace(new RegExp("pda/[^/]*/",""),"");
                var i = pageToRequest.indexOf("Comment");
                pageToRequest = "/lessonbuilder-tool/faces/" + pageToRequest.substring(i);
		$(this).load(pageToRequest, commentsLoaded);
	});

  document.getElementById("delete-comment-confirm-button")?.addEventListener("click", e => deleteButton());
});

/* only do this once if there is more than one comment block */
function commentsLoaded() {
	if (commentsToLoad > 1) {
	    commentsToLoad--;
	    return;
	}
	fixupHeights();
	setMainFrameHeight(window.name);
	
	$(".pointsBox").unbind("keyup");
	
	LSNGRD.initPointBoxes();
}

function loadMore(link) {
	$.ajaxSetup ({
		cache: false
	});
	
	var pageToRequest = $(link).parent().parent().find(".to-load").attr("href");
	var i = pageToRequest.indexOf("Comment");
	pageToRequest = "/lessonbuilder-tool/faces/" + pageToRequest.substring(i);
	
	commentsToLoad = $(link).parents(".replaceWithComments").size();
	$(link).parents(".replaceWithComments").load(pageToRequest, commentsLoaded);

}

function performHighlight() {
	$(".highlight-comment").effect("highlight", {}, 4000);
}

function replyToComment(link, replytext) {

	var evolved = $(link).parents(".commentsDiv").find(".evolved-box");
	
	if(noEditor) {
	    var body = $(link).parent().children(".commentBody");
	    // this should get the text out of the comment with newlines
	    // however innertext doesn't work on FF and I've heard rumors
	    // about IE 9. Hence provide a standard backup. It will handle
	    // newlines if they were entered via this text box, but 
	    // may not if entered in the editor
	    body = body.get(0).innerText || body.text().replace(/^\s*/,"").replace(/\n\s*/g,"\n");
	    body = replytext + '\n\n' + body.replace(/^/,"|  ").replace(/\n/g,"\n|  ") + '\n\n';
	    evolved.val(body);
	} else {
	    CKEDITOR.instances[evolved.children("textarea").attr("name")].setData(replytext + '<div style="border-left: 2px solid black; padding-left:6px">' + $(link).parent().children(".commentBody").html() + '</div>\n<p></p>', function() {
		    // this function is called after the insert happens. The goal is to move the cursor to the end
		    var range = this.createRange();
		    range.moveToElementEditEnd( range.root );
		    this.getSelection().selectRanges( [ range ] );
		});
	    evolved.focus();

	}
	
	$(link).parents(".commentsDiv").find(".comment-edit-id").val(null);
	$(link).parents(".commentsDiv").find(".submitButton").val(msg("simplepage.save_message"));

        switchEditors(link);

	return false;
}


function switchEditors(link, show) {
	if(show===undefined) show = true;
	
	var evolved;
	
	if (noEditor) {
		evolved = $(link).parents(".commentsDiv").find(".evolved-box");
		evolved.css('width', '600px');
		evolved.css('height', '175px');
	}else {
		evolved = $(link).parents(".commentsDiv").find(".evolved-box");
	}
	
	if(show) {

 	    evolved.show();
 	    //$(link).parents(".commentsDiv").find(".editarea").show();
  
 		if(noEditor) {
 		    evolved.focus();
 		} else {
 		    var frame = $(link).parents(".commentsDiv").find("iframe");
 
 		    // the builtin title is grossly too long, and not internationalized
 		    if (frame !== null) {
 		    	frame.attr("title", msg("simplepage.ckeditor"));
		    }
 
 		    // seem to need this to make focus show up in VoiceOver. Looks like it's
 		    // not seeing into the iframe, although Safari shows it as selected
 		    if (frame !== null) {
 			frame.focus();
 		    }
 		    CKEDITOR.instances[evolved.children("textarea").attr("name")].focus();
 		}
 
		var pos = evolved.offset();
		window.scrollTo(pos.left, pos.top);

		if (noEditor) {
		    // the submit expects HTML, so stick BRs at every newline
		    var submit = $(link).parents(".commentsDiv").find(".submitButton");
		   submit.click(function(link) {
			    var text = $(this).parents(".commentsDiv").find(".evolved-box");
			    text.val(text.val().replace(/\r\n/g, "<br/>\n").replace(/[\r\n]/g, "<br/>\n"));
			    return true;
			});
		}
		
		$(link).parents(".commentsDiv").find(".submitButton").show();
		$(link).parents(".commentsDiv").find(".cancelButton").show();
		
		$(link).parents(".commentsDiv").find(".switchLink").hide();
	}else {
		evolved.hide();
		if (noEditor) {
			evolved.val("");
		} else {
			CKEDITOR.instances[evolved.children("textarea").attr("name")].setData("");
		}
		
		$(link).parents(".commentsDiv").find(".submitButton").hide().val(msg("simplepage.save_message"));
		$(link).parents(".commentsDiv").find(".cancelButton").hide().val(msg("simplepage.cancel_message"));
		
		$(link).parents(".commentsDiv").find(".switchLink").show();
		$(link).parents(".commentsDiv").find(".comment-edit-id").val("");

	}
	
	if(ckEditor) {
		evolved.find("textarea").hide();
	}
	
	setMainFrameHeight(window.name);
	$(document).height($('body').height());
}

function deleteComment(link) {
	$.ajaxSetup ({
		cache: false
	});
	
	deleteDialogCommentURL = $(link).parent().children(".deleteComment").attr("href");
	var i = deleteDialogCommentURL.indexOf("Comment");
	deleteDialogCommentURL = "/lessonbuilder-tool/faces/" + deleteDialogCommentURL.substring(i);

	//var dialog = $(link).parents(".replaceWithComments").find(".delete-dialog");
	//$("#delete-dialog").children(".delete-dialog-comment-url").text(pageToRequest);
	
	originalDeleteDialogText = $("#delete-comment-confirm").text();
	$("#delete-comment-confirm").text(
			originalDeleteDialogText.replace("{}", link.parents(".commentDiv").find(".author").text()));
	
  const el = document.querySelector("#delete-comment-confirm-dialog");
  const modal = bootstrap.Modal.getOrCreateInstance(el);
  modal.show();
	
	commentToReload = $(link).parents(".replaceWithComments");


	
	//$(link).parents(".replaceWithComments").load(pageToRequest);
	
	//setMainFrameHeight(window.name);
}

function deleteButton() {
	$(commentToReload).load(deleteDialogCommentURL, commentsLoaded);
	//$("#delete-dialog").parents(".replaceWithComments").load($(dialog).children(".delete-dialog-comment-url").text());
	setMainFrameHeight(window.name);
  const el = document.querySelector("#delete-comment-confirm-dialog");
  const modal = bootstrap.Modal.getOrCreateInstance(el);
  modal.hide();
	$("#delete-comment-confirm").text(originalDeleteDialogText);
}

function edit(link, id) {
	var evolved = $(link).parents(".commentsDiv").find(".evolved-box");
	
	if(noEditor) {
	    var body = $(link).parent().children(".commentBody");
	    // this should get the text out of the comment with newlines
	    // however innertext doesn't work on FF and I've heard rumors
	    // about IE 9. Hence provide a standard backup. It will handle
	    // newlines if they were entered via this text box, but 
	    // may not if entered in the editor
	    body = body.get(0).innerText || body.text().replace(/^\s*/,"").replace(/\n\s*/g,"\n");
	    evolved.val(body);

	} else {
		CKEDITOR.instances[evolved.children("textarea").attr("name")].setData($(link).parent().children(".commentBody").html());
	}
	
	$(link).parents(".commentsDiv").find(".comment-edit-id").val(id);
	$(link).parents(".commentsDiv").find(".submitButton").val(msg("simplepage.save_message"));
	
	switchEditors(link);
}
