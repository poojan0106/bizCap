var SLDS=SLDS||{};SLDS["__internal/chunked/showcase/ui/components/tabs/base/example.jsx.js"]=webpackJsonpSLDS___internal_chunked_showcase([34,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137],{0:function(e,t){e.exports=React},121:function(e,t,a){"use strict";function l(e){return e&&e.__esModule?e:{default:e}}Object.defineProperty(t,"__esModule",{value:!0}),t.examples=t.states=void 0;var d=l(a(0)),s=l(a(26)),n=l(a(2)),r=a(8),m=a(46),c=a(28),u=(l(a(1)),function(e){return d.default.createElement(s.default,{className:e.className,selectedIndex:e.selectedIndex||0},d.default.createElement(s.default.Item,{title:"Item One",id:"tab-default-1"},e.itemOneContent||"Item One Content"),d.default.createElement(s.default.Item,{title:"Item Two",id:"tab-default-2"},"Item Two Content"),d.default.createElement(s.default.Item,{title:"Item Three",id:"tab-default-3"},"Item Three Content"))}),o=function(e){return d.default.createElement("div",{className:"demo-only",style:{height:"10rem"}},d.default.createElement(s.default,null,d.default.createElement(s.default.Item,{title:"Item One",id:"tab-default-1"},"Item One Content"),d.default.createElement(s.default.Item,{title:"Item Two",id:"tab-default-2"},"Item Two Content"),d.default.createElement(s.default.Item,{title:"Item Three",id:"tab-default-3"},"Item Three Content"),d.default.createElement(s.default.Item,{title:"Item Four",id:"tab-default-4"},d.default.createElement("h2",null,"Item Four Content")),d.default.createElement(s.default.Item,{title:"Item Five",id:"tab-default-5"},d.default.createElement("h2",null,"Item Five Content")),d.default.createElement(s.default.Item,{title:"Item Six",id:"tab-default-6"},d.default.createElement("h2",null,"Item Six Content")),d.default.createElement(s.default.Item,{title:"Item Seven",id:"tab-default-7"},d.default.createElement("h2",null,"Item Seven Content")),d.default.createElement(s.default.ItemOverflow,{title:"More tabs",className:"slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open slds-tabs_default__item"},d.default.createElement("a",{className:"slds-button slds-tabs_default__link",href:"javascript:void(0);","aria-haspopup":"true"},d.default.createElement("span",{className:"slds-truncate",title:"More tabs"},"More ",d.default.createElement("span",{className:"slds-assistive-text"},"tabs")),d.default.createElement(n.default,{className:"slds-button__icon slds-button__icon_x-small",sprite:"utility",symbol:"down"})),d.default.createElement(r.Menu,{className:"slds-dropdown_right"},d.default.createElement(r.MenuList,{className:"slds-dropdown_length-with-icon-10"},d.default.createElement(r.MenuItem,null,d.default.createElement(n.default,{className:"slds-icon slds-icon_small slds-icon-standard-account slds-m-right_small",sprite:"standard",symbol:"account"}),"Accounts"),d.default.createElement(r.MenuItem,null,d.default.createElement(n.default,{className:"slds-icon slds-icon_small slds-icon-standard-approval slds-m-right_small",sprite:"standard",symbol:"approval"}),"Approvals"),d.default.createElement(r.MenuItem,null,d.default.createElement(n.default,{className:"slds-icon slds-icon_small slds-icon-standard-lead slds-m-right_small",sprite:"standard",symbol:"lead"}),"Lead"))))))};t.default=d.default.createElement(u,null);t.states=[{id:"selected",label:"Item Two Selected",element:d.default.createElement(u,{selectedIndex:1})}],t.examples=[{id:"overflow",label:"Overflowing items",element:d.default.createElement(o,null)},{id:"nested",label:"With Nested Scoped Tabs",element:d.default.createElement(u,{itemOneContent:d.default.createElement(m.Default,null)})},{id:"card-look",label:"Tab Card-look",element:d.default.createElement(s.default,{className:"slds-tabs_card",selectedIndex:0},d.default.createElement(s.default.Item,{title:"Item One",id:"tab-default-1"},d.default.createElement(c.Card,null,d.default.createElement(c.CardHeader,{symbol:"contact",actions:!0},d.default.createElement("span",{className:"slds-text-heading_small"},"Card Header")),d.default.createElement(c.CardBody,{className:"slds-card__body_inner"},"This is a card inside an `.slds-tabs_card` to show how styling is removed when cards are nested inside."),d.default.createElement(c.CardFooter,null,"Card Footer")),d.default.createElement(c.Card,null,d.default.createElement(c.CardHeader,{symbol:"contact",actions:!0},d.default.createElement("span",{className:"slds-text-heading_small"},"Card Header")),d.default.createElement(c.CardBody,{className:"slds-card__body_inner"},"This is a card inside an `.slds-tabs_card` to show how styling is removed when cards are nested inside."),d.default.createElement(c.CardFooter,null,"Card Footer")),d.default.createElement(c.Card,{className:"slds-card_boundary"},d.default.createElement(c.CardHeader,{symbol:"contact",actions:!0},d.default.createElement("span",{className:"slds-text-heading_small"},"Card Header")),d.default.createElement(c.CardBody,{className:"slds-card__body_inner"},"This is a card inside an `.slds-tabs_card` to illustrate how `.slds-card_boundary` adds a rounded border when desired."),d.default.createElement(c.CardFooter,null,"Card Footer")),d.default.createElement(c.Card,{className:"slds-card_boundary"},d.default.createElement(c.CardHeader,{symbol:"contact",actions:!0},d.default.createElement("span",{className:"slds-text-heading_small"},"Card Header")),d.default.createElement(c.CardBody,{className:"slds-card__body_inner"},"This is a card inside an `.slds-tabs_card` to illustrate how `.slds-card_boundary` adds a rounded border when desired."),d.default.createElement(c.CardFooter,null,"Card Footer"))),d.default.createElement(s.default.Item,{title:"Item Two",id:"tab-default-2"},"Item Two Content"),d.default.createElement(s.default.Item,{title:"Item Three",id:"tab-default-3"},"Item Three Content"))}]}},[121]);