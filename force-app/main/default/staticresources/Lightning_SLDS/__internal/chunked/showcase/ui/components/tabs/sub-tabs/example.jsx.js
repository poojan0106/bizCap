var SLDS=SLDS||{};SLDS["__internal/chunked/showcase/ui/components/tabs/sub-tabs/example.jsx.js"]=webpackJsonpSLDS___internal_chunked_showcase([33,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137],{0:function(e,t){e.exports=React},122:function(e,t,a){"use strict";function l(e){return e&&e.__esModule?e:{default:e}}Object.defineProperty(t,"__esModule",{value:!0}),t.states=void 0;var s=l(a(0)),b=l(a(1)),d=l(a(2)),n=a(3),i=l(a(4)),u=function(e){return s.default.createElement("li",{className:(0,b.default)("slds-tabs_default__item slds-sub-tabs__item slds-grid slds-grid_vertical-align-center",{"slds-has-notification":e.hasNotification,"slds-has-focus":e.hasFocus,"slds-active":e.active},e.className),role:"presentation"},s.default.createElement("a",{"aria-controls":e.tabPanelId,"aria-selected":e.active?"true":"false",className:"slds-tabs_default__link slds-p-horizontal_xx-small",href:"javascript:void(0);",id:e.tabItemId,role:"tab",tabIndex:e.active?"0":"-1",title:e.title||"Subtab Name"},e.itemUnsaved?s.default.createElement("abbr",{className:"slds-indicator_unsaved",title:"Tab Not Saved","aria-label":"Tab Not Saved"},"*"):null,e.hasNotification&&s.default.createElement("span",{"aria-label":"New Activity",className:"slds-indicator_unread",role:"alert",title:"New Activity"},s.default.createElement("span",{className:"slds-assistive-text"},"New activity in Tab: ",e.title||"Subtab Name")),s.default.createElement("div",{className:"slds-icon_container",title:i.default.startCase(e.symbol)||"Case"},s.default.createElement(d.default,{className:"slds-icon slds-icon_small slds-icon-text-default",sprite:"standard",symbol:e.symbol||"case"}),s.default.createElement("span",{className:"slds-assistive-text"},i.default.startCase(e.symbol)||"Case",":")),s.default.createElement("span",{className:(0,b.default)("slds-truncate",e.pinned?"slds-assistive-text":null),title:e.title||"Subtab Name"},e.title||"Subtab Name")),e.menuIcon?s.default.createElement("div",{className:(0,b.default)("slds-dropdown-trigger slds-dropdown-trigger_click slds-p-left_none slds-p-right_none","true"==e.actionOverflow?"slds-is-open":null)},s.default.createElement(n.ButtonIcon,{className:"slds-button_icon-container slds-button_icon-x-small",tabIndex:e.active?"0":"-1",symbol:"chevrondown","aria-haspopup":"true",assistiveText:"Actions for "+e.title,title:"Actions for "+e.title})):null,s.default.createElement("div",{className:(0,b.default)("slds-col_bump-left slds-p-left_none slds-p-right_none",e.pinned?"slds-assistive-text":null)},s.default.createElement(n.ButtonIcon,{className:"slds-button_icon-container slds-button_icon-x-small",tabIndex:e.active?"0":"-1",symbol:"close",assistiveText:"Close "+e.title,title:"Close "+e.title})))};t.default=s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{active:!0,title:"00071938",tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat"})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content"));t.states=[{id:"subtabs-has-focus",label:"Tab - Focus",element:s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{title:"00071938",id:"subtab-01",active:!0,hasFocus:!0,tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat"})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content")),script:"\n      document.getElementById('subtab-01').focus()\n    "},{id:"subtabs-unsaved",label:"Unsaved Tab",element:s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{title:"00071938",active:!0,itemUnsaved:!0,tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat"})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content"))},{id:"subtabs-borders",label:"With Borders",element:s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{title:"00071938",active:!0,className:"slds-border_right slds-border_left",tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat",className:"slds-border_right"})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content"))},{id:"subtabs-menu",label:"Tab - Action Overflow",element:s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{title:"00071938",active:!0,menuIcon:!0,tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat",menuIcon:!0})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content"))},{id:"subtabs-notification",label:"Tab Notification",element:s.default.createElement("div",{className:"slds-tabs_default slds-sub-tabs"},s.default.createElement("ul",{className:"slds-tabs_default__nav",role:"tablist"},s.default.createElement(u,{title:"00071938",active:!0,tabItemId:"subtab-tabitem-01",tabPanelId:"subtab-tabpanel-01"}),s.default.createElement(u,{title:"Chat - Customer",hasNotification:!0,tabItemId:"subtab-tabitem-02",tabPanelId:"subtab-tabpanel-02",symbol:"live_chat"})),s.default.createElement("div",{className:"slds-tabs_default__content slds-show",id:"subtab-tabpanel-01",role:"tabpanel","aria-labelledby":"subtab-tabitem-01"},"Item One Content"),s.default.createElement("div",{className:"slds-tabs_default__content slds-hide",id:"subtab-tabpanel-02",role:"tabpanel","aria-labelledby":"subtab-tabitem-02"},"Item Two Content"))}]}},[122]);