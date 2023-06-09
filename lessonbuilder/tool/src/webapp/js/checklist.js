(function (checklist, $, undefined) {
    var oldloc;
    var checklistItemName = "checklist-item-name";
    var checklistItemLink = "checklist-item-link";
    var dialogRadios = $("input[name=external-link-radios]");
    var externalLinkItemsAvailable = [];


    checklist.init = function () {
        $("input[name=external-link-radios]").each(function() {
            externalLinkItemsAvailable.push($(this).val());
        });

        if(externalLinkItemsAvailable.length == 0) {
            $(".external-link").hide();
        }

        loadPreviouslySavedChecklistItems();

        var confirmMsg = $('#deleteButtonLangSupp').html();
        $('.deleteButton').click(function () {
            return confirm(confirmMsg);
        });

        $('#additionalSettings').accordion({
            collapsible: true,
            active: false,
            heightStyle: "content"
        });

        // Hide group header if no group div
        if ($("#grouplist").length === 0) {
            $("#groupHeader").hide();
        }

        //$("#externalLink-dialog-close").click(function(e){
        document.getElementById("externalLink-dialog")?.addEventListener("hide.bs.modal", e => {

            oldloc.focus();
            clearDialogRadios();
        });

        // "submit" the external link dialog
        document.getElementById("externalLink-dialog-submit")?.addEventListener("click", function (e) {

            e.preventDefault();
            var selected = $("input[name=external-link-radios]:checked").val();
            var target = $("#item-id").val();
            $("input[name=checklist-item-link" + target + "]").val(selected);
            $("#external-link-unlink-" + target).show();

            const el = document.getElementById("externalLink-dialog");
            const modal = bootstrap.Modal.getOrCreateInstance(el);
            modal.hide();

            updateUsedExternalLinks(selected);
            clearDialogRadios();
        });

        //add new checklist item
        $("#addChecklistItemButton").click(function(e){
          e.preventDefault();
          checklist.addChecklistItem();
        });

        // save all checklist items
        $("#save").click(function(){
           return checklist.validateChecklistForm();
        });
    };

    // Clones one of the checklist items and appends it to the end of the list
    checklist.addChecklistItem = function () {
        var clonedAnswer = $("#copyableChecklistItemDiv").clone(true);
        clonedAnswer.show();
        var num = 0;
        var itemNamesOnScreen = document.getElementsByClassName('checklist-item-name');
        for(var count=0; count<itemNamesOnScreen.length; count++){  //observe all the named items currently onscreen to try and get the largest index
            var nameNow = itemNamesOnScreen[count].name.replace('checklist-item-name','0'); //get the index number of the current item alone, adding 0 just in case there isn't one
            if(parseInt(nameNow) > num){    //if the index of the current item is larger than the old one, we have a new highest number.
                num = parseInt(nameNow);
            }
        }
        num = num + 1;  //num should be incremented by 1 over the largest existing index.

        clonedAnswer.find(".checklist-item-id").val("-1");
        clonedAnswer.find(".checklist-item-name").val("");

        clonedAnswer.attr("id", "checklistItemDiv" + num);

        // Each input has to be renamed so that RSF will recognize them as distinct
        clonedAnswer.find("[name='checklist-item-complete']")
            .attr("name", "checklist-item-complete" + num)
            .addClass("checklist-item-complete");
        clonedAnswer.find("[name='checklist-item-complete-fossil']")
            .attr("name", "checklist-item-complete" + num + "-fossil");
        clonedAnswer.find("[name='checklist-item-id']")
            .attr("name", "checklist-item-id" + num);
        clonedAnswer.find("[for='checklist-item-name']")
            .attr("for", "checklist-item-name" + num);
        clonedAnswer.find("[name='checklist-item-name']")
            .attr("name", "checklist-item-name" + num);
        clonedAnswer.find("[name='checklist-item-link']").attr("name", "checklist-item-link" + num);

        clonedAnswer.find(".checklist-item-link").attr("id", "checklist-item-link-" + num);
        clonedAnswer.find("#external-link-").attr("id", "external-link-" + num);
        clonedAnswer.find("#external-link-unlink-").attr("id", "external-link-unlink-" + num);

        clonedAnswer.appendTo("#createdChecklistItems");

        $('#createdChecklistItems').sortable({
            handle: ".handle"
        });

        // external link button (opens dialog box)
        $("#external-link-" + num).click({id: num}, function(e) {
            e.preventDefault();

            oldloc = $(this);
            $("#item-id").val(e.data.id);
            var selected = $("input[name='" + checklistItemLink + e.data.id +"']").val();
            var array = getUsedExternalLinks();

           dialogRadios.each(function() {
               if($(this).val() === selected) {
                   $(this).prop('checked', true);
               }
               var dialogRadio = $(this);
               $.each(array, function(index, item) {
                   if(dialogRadio.val() !== selected && dialogRadio.val() === item.toString()) {
                       dialogRadio.prop('disabled', true);
                   }
               })
            });

            const el = document.getElementById("externalLink-dialog");
            const modal = bootstrap.Modal.getOrCreateInstance(el);
            modal.show();
        });

        // external link unlinking (hide button and set up click event)
        clonedAnswer.find(".external-unlink").hide();
        $("#external-link-unlink-" + num).click({id: num}, function(e) {
            e.preventDefault();
            var cacheChecklistItemLink = $("#checklist-item-link-" + num);
            removeUsedExternalLinks(cacheChecklistItemLink.val());
            cacheChecklistItemLink.val("");
            $(this).hide();
        });

        // delete checklist Item.
        clonedAnswer.find(".deleteItemLink").click({id: num}, function(e){
            e.preventDefault();
            var linkedVal = $("#checklist-item-link-" + e.data.id).val();
            if(linkedVal !== "") {
                removeUsedExternalLinks(linkedVal);
            }
            $("#checklistItemDiv" + e.data.id).remove();
        });

        return clonedAnswer;
    };

    checklist.validateChecklistForm = function () {
        if ($.trim($('#name').val()) === '') {
            $('#checklist-error').text(msg("simplepage.checklist-name-required"));
            $('#checklist-error-container').show();
            $(window).scrollTop(0);
            return false;
        } else {
            $('#checklist-error-container').hide();
            return updateChecklistItems();
        }
    };

    function msg(s) {
        var m = document.getElementById(s);
        if (m === null) {
            return s;
        } else
            return m.innerHTML;
    }

    function loadPreviouslySavedChecklistItems() {

        var attributeString = $('#attributeString').val();
        if (attributeString === null || attributeString === '') {
            return;
        }
        var obj = $.parseJSON(attributeString);
        if (obj && obj.checklistItems !== null) {
            $.each(obj.checklistItems, function (index, el) {
                var id = el.id;
                var name = el.name;
                var link = el.link;
                var linkPresent = false;
                if(link === undefined || link ===  -1) {
                    link = "";
                } else {
                    linkPresent = true;
                    if($.inArray(link.toString(), externalLinkItemsAvailable) === -1) {
                        linkPresent = false;
                        link = "";
                    }
                }

                var itemSlot = checklist.addChecklistItem();

                itemSlot.find(".checklist-item-id").val(id);
                itemSlot.find("." + checklistItemName).val(name);
                itemSlot.find("." + checklistItemLink).val(link);
                if(linkPresent) {
                    updateUsedExternalLinks(link);
                    itemSlot.find(".external-unlink").show();
                }
            });
        }
    }

    function updateChecklistItems() {
        $(".checklist-item-complete").each(function (index, el) {
            var id = $(el).parent().find(".checklist-item-id").val();
            var text = $.trim($(el).parent().find("." + checklistItemName).val());
            var link = $(el).parent().find("." + checklistItemLink).val();

            $(el).val(JSON.stringify({"index": index, "id": id, "text": text, "link": link}));
        });

        return true;
    }

    function getUsedExternalLinks() {

        const json = sessionStorage.getItem("externalLinkItemsUsed");
        return json ? JSON.parse(json) : [];
    }

    function updateUsedExternalLinks(val) {

      if (val) {
        const array = getUsedExternalLinks();
        array.push(val);
        sessionStorage.setItem("externalLinkItemsUsed", JSON.stringify(array))
      }
    }

    function removeUsedExternalLinks(removeItem) {

        const array = getUsedExternalLinks().filter(v => v != removeItem);
        sessionStorage.setItem("externalLinkItemsUsed", JSON.stringify(array))
    }

    function clearDialogRadios() {
        dialogRadios.each(function() {
            var dialogRadio = $(this);
            dialogRadio.prop('checked', false);
            dialogRadio.prop('disabled', false);
        })
    }

}(window.checklist = window.checklist || {}, jQuery));
