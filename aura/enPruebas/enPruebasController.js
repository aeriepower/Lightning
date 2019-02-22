({
    handleRowAction : function(component,  event, helper){

        var params = event.getParam('arguments'),
            workspaceAPI = component.find("workspace"),
            focusedTabId;

        workspaceAPI.getFocusedTabInfo().then(function(response) {
            focusedTabId = response.tabId;
        })

        workspaceAPI.openSubtab({
            parentTabId: focusedTabId,
            url:'/lightning/r/' + params.sObjectName + '/'+ params.Id + '/view',
            focus: true
        })
    },
})