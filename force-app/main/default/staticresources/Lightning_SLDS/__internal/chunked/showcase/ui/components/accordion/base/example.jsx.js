var SLDS=SLDS||{};SLDS["__internal/chunked/showcase/ui/components/accordion/base/example.jsx.js"]=webpackJsonpSLDS___internal_chunked_showcase([95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137],{0:function(e,t){e.exports=React},48:function(e,t,a){"use strict";function n(e){return e&&e.__esModule?e:{default:e}}Object.defineProperty(t,"__esModule",{value:!0}),t.states=void 0;var s=n(a(0)),c=n(a(2)),l=n(a(1)),r=(a(30),"accordion-details-01"),d="accordion-details-02",o="accordion-details-03",i=function(e){return s.default.createElement("ul",{className:(0,l.default)("slds-accordion",e.className)},e.children)},m=function(e){return s.default.createElement("li",{className:"slds-accordion__list-item"},s.default.createElement("section",{className:(0,l.default)("slds-accordion__section",e.isOpen?"slds-is-open":null)},s.default.createElement("div",{className:(0,l.default)("slds-accordion__summary",e.className)},s.default.createElement("h3",{className:(0,l.default)("slds-text-heading_small slds-accordion__summary-heading",e.className)},s.default.createElement("button",{"aria-controls":e.referenceId,"aria-expanded":e.isOpen,className:"slds-button slds-button_reset slds-accordion__summary-action"},s.default.createElement(c.default,{className:"slds-accordion__summary-action-icon slds-button__icon slds-button__icon_left",sprite:"utility",symbol:"switch"}),s.default.createElement("span",{className:"slds-truncate",title:e.summary},e.summary))),s.default.createElement("button",{className:"slds-button slds-button_icon slds-button_icon-border-filled slds-button_icon-x-small slds-shrink-none","aria-haspopup":"true"},s.default.createElement(c.default,{className:"slds-button__icon",sprite:"utility",symbol:"down"}),s.default.createElement("span",{className:"slds-assistive-text"},"More Options"))),s.default.createElement("div",{"aria-hidden":!e.isOpen,className:(0,l.default)("slds-accordion__content",e.className),id:e.referenceId},e.children)))};t.default=s.default.createElement(i,null,s.default.createElement(m,{summary:"Accordion summary",isOpen:!0,referenceId:r},"Accordion details - A"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:d},"Accordion details - B"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:o},"Accordion details - C"));t.states=[{id:"section-one-open",label:"Section one open",element:s.default.createElement(i,null,s.default.createElement(m,{summary:"Accordion summary",isOpen:!0,referenceId:r},"Accordion details - A"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:d},"Accordion details - B"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:o},"Accordion details - C"))},{id:"section-two-open",label:"Section two open",element:s.default.createElement(i,null,s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:r},"Accordion details - A"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!0,referenceId:d},"Accordion details - B"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:o},"Accordion details - C"))},{id:"section-three-open",label:"Section three open",element:s.default.createElement(i,null,s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:r},"Accordion details - A"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:d},"Accordion details - B"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!0,referenceId:o},"Accordion details - C"))},{id:"styled",label:"Styled",element:s.default.createElement("div",{className:"slds-card"},s.default.createElement(i,null,s.default.createElement(m,{summary:"Accordion summary",isOpen:!0,referenceId:r},"Accordion details - A"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:d},"Accordion details - B"),s.default.createElement(m,{summary:"Accordion summary",isOpen:!1,referenceId:o},"Accordion details - C")))}]}},[48]);