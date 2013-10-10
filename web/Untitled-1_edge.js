/**
 * Adobe Edge: symbol definitions
 */
(function($, Edge, compId){
//images folder
var im='images/';

var fonts = {};


var resources = [
];
var symbols = {
"stage": {
   version: "2.0.1",
   minimumCompatibleVersion: "2.0.0",
   build: "2.0.1.268",
   baseState: "Base State",
   initialState: "Base State",
   gpuAccelerate: false,
   resizeInstances: false,
   content: {
         dom: [
         {
            id:'_1',
            type:'image',
            rect:['-47px','121px','257px','299px','auto','auto'],
            tabindex:'8',
            fill:["rgba(0,0,0,0)",im+"1.png",'0px','0px','340px','340px']
         }],
         symbolInstances: [

         ]
      },
   states: {
      "Base State": {
         "${_Stage}": [
            ["color", "background-color", 'rgba(255,255,255,1)'],
            ["style", "overflow", 'hidden'],
            ["style", "height", '500px'],
            ["style", "width", '1440px']
         ],
         "${__1}": [
            ["motion", "location", '146.23341288374px 302.61671845694px'],
            ["style", "opacity", '1'],
            ["style", "height", '363px'],
            ["style", "background-size", [340,340], {valueTemplate:'@@0@@px @@1@@px'} ],
            ["style", "width", '386px']
         ]
      }
   },
   timelines: {
      "Default Timeline": {
         fromState: "Base State",
         toState: "",
         duration: 3000,
         autoPlay: true,
         timeline: [
            { id: "eid9", tween: [ "style", "${__1}", "width", '340px', { fromValue: '386px'}], position: 0, duration: 2875 },
            { id: "eid14", tween: [ "style", "${__1}", "width", '278px', { fromValue: '340px'}], position: 2875, duration: 125 },
            { id: "eid2", tween: [ "motion", "${__1}", [[146.23,302.62,0,0],[386.13,370.55,679.52,33.27,404.64,2.29],[1032.6,274.72,542.4,-30.4,1260.03,-29.2],[1313.62,295.48,0,0]]], position: 0, duration: 3000 },
            { id: "eid5", tween: [ "style", "${__1}", "opacity", '0', { fromValue: '1'}], position: 2000, duration: 1000 },
            { id: "eid13", tween: [ "style", "${__1}", "height", '363px', { fromValue: '363px'}], position: 0, duration: 0 }         ]
      }
   }
}
};


Edge.registerCompositionDefn(compId, symbols, fonts, resources);

/**
 * Adobe Edge DOM Ready Event Handler
 */
$(window).ready(function() {
     Edge.launchComposition(compId);
});
})(jQuery, AdobeEdge, "EDGE-9337950");
