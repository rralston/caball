// Peity jQuery plugin version 0.6.0
// (c) 2011 Ben Pickles
//
// http://benpickles.github.com/peity/
//
// Released under MIT license.
(function(e,t){function n(e,n){var r=t.createElement("canvas");return r.setAttribute("width",e*i),r.setAttribute("height",n*i),i!=1&&r.setAttribute("style","width:"+e+"px;height:"+n+"px"),r}var r=e.fn.peity=function(n,i){return t.createElement("canvas").getContext&&this.each(function(){e(this).change(function(){var t=e.extend({},i),s=this;e.each(t,function(n,r){e.isFunction(r)&&(t[n]=r.call(s))});var o=e(this).html();r.graphers[n].call(this,e.extend({},r.defaults[n],t)),e(this).trigger("chart:changed",o)}).trigger("change")}),this};r.graphers={},r.defaults={},r.add=function(e,t,n){r.graphers[e]=n,r.defaults[e]=t};var i=window.devicePixelRatio||1;r.add("pie",{colours:["#FFF4DD","#FF9900"],delimeter:"/",diameter:16},function(t){var r=e(this),i=r.text().split(t.delimeter),s=parseFloat(i[0]),u=parseFloat(i[1]),i=-Math.PI/2,s=s/u*Math.PI*2,u=n(t.diameter,t.diameter),a=u.getContext("2d"),f=u.width/2;a.beginPath(),a.moveTo(f,f),a.arc(f,f,f,s+i,s==0?Math.PI*2:i,!1),a.fillStyle=t.colours[0],a.fill(),a.beginPath(),a.moveTo(f,f),a.arc(f,f,f,i,s+i,!1),a.fillStyle=t.colours[1],a.fill(),r.wrapInner(e("<span>").hide()).append(u)}),r.add("line",{colour:"#c6d9fd",strokeColour:"#4d89f9",strokeWidth:1,delimeter:",",height:16,max:null,min:0,width:32},function(t){var r=e(this),s=n(t.width,t.height),u=r.text().split(t.delimeter);u.length==1&&u.push(u[0]);var a=Math.max.apply(Math,u.concat([t.max])),f=Math.min.apply(Math,u.concat([t.min])),l=s.getContext("2d"),c=s.width,h=s.height,p=c/(u.length-1),a=h/(a-f),d=[],v;l.beginPath(),l.moveTo(0,h+f*a);for(v=0;v<u.length;v++){var g=v*p,y=h-a*(u[v]-f);d.push({x:g,y:y}),l.lineTo(g,y)}l.lineTo(c,h+f*a),l.fillStyle=t.colour,l.fill();if(t.strokeWidth){l.beginPath(),l.moveTo(0,d[0].y);for(v=0;v<d.length;v++)l.lineTo(d[v].x,d[v].y);l.lineWidth=t.strokeWidth*i,l.strokeStyle=t.strokeColour,l.stroke()}r.wrapInner(e("<span>").hide()).append(s)}),r.add("bar",{colour:"#4D89F9",delimeter:",",height:16,max:null,min:0,width:32},function(t){var r=e(this),s=r.text().split(t.delimeter),u=Math.max.apply(Math,s.concat([t.max])),a=Math.min.apply(Math,s.concat([t.min])),f=n(t.width,t.height),l=f.getContext("2d"),c=f.height,u=c/(u-a),h=i/2,p=(f.width+h)/s.length;l.fillStyle=t.colour;for(t=0;t<s.length;t++)l.fillRect(t*p,c-u*(s[t]-a),p-h,u*s[t]);r.wrapInner(e("<span>").hide()).append(f)})})(jQuery,document);