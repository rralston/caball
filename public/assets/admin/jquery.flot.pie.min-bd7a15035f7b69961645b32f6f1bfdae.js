!function(t){function e(e){function s(t,e){e.series.pie.show&&(e.grid.show=!1,"auto"==e.series.pie.label.show&&(e.series.pie.label.show=e.legend.show?!1:!0),"auto"==e.series.pie.radius&&(e.series.pie.radius=e.series.pie.label.show?.75:1),e.series.pie.tilt>1&&(e.series.pie.tilt=1),e.series.pie.tilt<0&&(e.series.pie.tilt=0),t.hooks.processDatapoints.push(a),t.hooks.drawOverlay.push(C),t.hooks.draw.push(u))}function o(t,e){var i=t.getOptions();i.series.pie.show&&i.grid.hoverable&&e.unbind("mousemove").mousemove(m),i.series.pie.show&&i.grid.clickable&&e.unbind("click").click(g)}function r(t){for(var e=0;e<t.length;++e){var i=parseFloat(t[e].data[0][1]);i&&(E+=i)}}function a(e){z||(z=!0,k=e.getCanvas(),S=t(k).parent(),n=e.getOptions(),e.setData(h(e.getData())))}function l(){N=S.children().filter(".legend").children().width(),T=Math.min(k.width,k.height/n.series.pie.tilt)/2,M=k.height/2+n.series.pie.offset.top,D=k.width/2,"auto"==n.series.pie.offset.left?n.legend.position.match("w")?D+=N/2:D-=N/2:D+=n.series.pie.offset.left,T>D?D=T:D>k.width-T&&(D=k.width-T)}function c(t){for(var e=0;e<t.length;++e)"number"==typeof t[e].data?t[e].data=[[1,t[e].data]]:("undefined"==typeof t[e].data||"undefined"==typeof t[e].data[0])&&("undefined"!=typeof t[e].data&&"undefined"!=typeof t[e].data.label&&(t[e].label=t[e].data.label),t[e].data=[[1,0]]);return t}function h(t){t=c(t),r(t);for(var e=0,i=0,s=n.series.pie.combine.color,o=[],a=0;a<t.length;++a)t[a].data[0][1]=parseFloat(t[a].data[0][1]),t[a].data[0][1]||(t[a].data[0][1]=0),t[a].data[0][1]/E<=n.series.pie.combine.threshold?(e+=t[a].data[0][1],i++,s||(s=t[a].color)):o.push({data:[[1,t[a].data[0][1]]],color:t[a].color,label:t[a].label,angle:t[a].data[0][1]*2*Math.PI/E,percent:100*(t[a].data[0][1]/E)});return i>0&&o.push({data:[[1,e]],color:s,label:n.series.pie.combine.label,angle:e*2*Math.PI/E,percent:100*(e/E)}),o}function u(e,i){function s(){ctx.clearRect(0,0,k.width,k.height),S.children().filter(".pieLabel, .pieLabelBackground").remove()}function o(){var t=5,e=15,i=10,s=.02;if(n.series.pie.radius>1)var o=n.series.pie.radius;else var o=T*n.series.pie.radius;if(!(o>=k.width/2-t||o*n.series.pie.tilt>=k.height/2-e||i>=o)){ctx.save(),ctx.translate(t,e),ctx.globalAlpha=s,ctx.fillStyle="#000",ctx.translate(D,M),ctx.scale(1,n.series.pie.tilt);for(var r=1;i>=r;r++)ctx.beginPath(),ctx.arc(0,0,o,0,2*Math.PI,!1),ctx.fill(),o-=r;ctx.restore()}}function r(){function e(e,i,n){0>=e||(n?ctx.fillStyle=i:(ctx.strokeStyle=i,ctx.lineJoin="round"),ctx.beginPath(),Math.abs(e-2*Math.PI)>1e-9?ctx.moveTo(0,0):t.browser.msie&&(e-=1e-4),ctx.arc(0,0,s,o,o+e,!1),ctx.closePath(),o+=e,n?ctx.fill():ctx.stroke())}function i(){function e(e,i,o){if(0!=e.data[0][1]){var r,a=n.legend.labelFormatter,l=n.series.pie.label.formatter;r=a?a(e.label,e):e.label,l&&(r=l(r,e));var c=(i+e.angle+i)/2,h=D+Math.round(Math.cos(c)*s),u=M+Math.round(Math.sin(c)*s)*n.series.pie.tilt,d='<span class="pieLabel" id="pieLabel'+o+'" style="position:absolute;top:'+u+"px;left:"+h+'px;">'+r+"</span>";S.append(d);var f=S.children("#pieLabel"+o),p=u-f.height()/2,m=h-f.width()/2;if(f.css("top",p),f.css("left",m),(0-p>0||0-m>0||k.height-(p+f.height())<0||k.width-(m+f.width())<0)&&(A=!0),0!=n.series.pie.label.background.opacity){var g=n.series.pie.label.background.color;null==g&&(g=e.color);var v="top:"+p+"px;left:"+m+"px;";t('<div class="pieLabelBackground" style="position:absolute;width:'+f.width()+"px;height:"+f.height()+"px;"+v+"background-color:"+g+';"> </div>').insertBefore(f).css("opacity",n.series.pie.label.background.opacity)}}}var i=startAngle;if(n.series.pie.label.radius>1)var s=n.series.pie.label.radius;else var s=T*n.series.pie.label.radius;for(var o=0;o<a.length;++o)a[o].percent>=100*n.series.pie.label.threshold&&e(a[o],i,o),i+=a[o].angle}if(startAngle=Math.PI*n.series.pie.startAngle,n.series.pie.radius>1)var s=n.series.pie.radius;else var s=T*n.series.pie.radius;ctx.save(),ctx.translate(D,M),ctx.scale(1,n.series.pie.tilt),ctx.save();for(var o=startAngle,r=0;r<a.length;++r)a[r].startAngle=o,e(a[r].angle,a[r].color,!0);ctx.restore(),ctx.save(),ctx.lineWidth=n.series.pie.stroke.width,o=startAngle;for(var r=0;r<a.length;++r)e(a[r].angle,n.series.pie.stroke.color,!1);ctx.restore(),d(ctx),n.series.pie.label.show&&i(),ctx.restore()}if(S){ctx=i,l();for(var a=e.getData(),c=0;A&&P>c;)A=!1,c>0&&(T*=I),c+=1,s(),n.series.pie.tilt<=.8&&o(),r();c>=P&&(s(),S.prepend('<div class="error">Could not draw pie with labels contained inside canvas</div>')),e.setSeries&&e.insertLegend&&(e.setSeries(a),e.insertLegend())}}function d(t){n.series.pie.innerRadius>0&&(t.save(),innerRadius=n.series.pie.innerRadius>1?n.series.pie.innerRadius:T*n.series.pie.innerRadius,t.globalCompositeOperation="destination-out",t.beginPath(),t.fillStyle=n.series.pie.stroke.color,t.arc(0,0,innerRadius,0,2*Math.PI,!1),t.fill(),t.closePath(),t.restore(),t.save(),t.beginPath(),t.strokeStyle=n.series.pie.stroke.color,t.arc(0,0,innerRadius,0,2*Math.PI,!1),t.stroke(),t.closePath(),t.restore())}function f(t,e){for(var i=!1,n=-1,s=t.length,o=s-1;++n<s;o=n)(t[n][1]<=e[1]&&e[1]<t[o][1]||t[o][1]<=e[1]&&e[1]<t[n][1])&&e[0]<(t[o][0]-t[n][0])*(e[1]-t[n][1])/(t[o][1]-t[n][1])+t[n][0]&&(i=!i);return i}function p(t,i){for(var n=e.getData(),s=e.getOptions(),o=s.series.pie.radius>1?s.series.pie.radius:T*s.series.pie.radius,r=0;r<n.length;++r){var a=n[r];if(a.pie.show){if(ctx.save(),ctx.beginPath(),ctx.moveTo(0,0),ctx.arc(0,0,o,a.startAngle,a.startAngle+a.angle,!1),ctx.closePath(),x=t-D,y=i-M,ctx.isPointInPath){if(ctx.isPointInPath(t-D,i-M))return ctx.restore(),{datapoint:[a.percent,a.data],dataIndex:0,series:a,seriesIndex:r}}else if(p1X=o*Math.cos(a.startAngle),p1Y=o*Math.sin(a.startAngle),p2X=o*Math.cos(a.startAngle+a.angle/4),p2Y=o*Math.sin(a.startAngle+a.angle/4),p3X=o*Math.cos(a.startAngle+a.angle/2),p3Y=o*Math.sin(a.startAngle+a.angle/2),p4X=o*Math.cos(a.startAngle+a.angle/1.5),p4Y=o*Math.sin(a.startAngle+a.angle/1.5),p5X=o*Math.cos(a.startAngle+a.angle),p5Y=o*Math.sin(a.startAngle+a.angle),arrPoly=[[0,0],[p1X,p1Y],[p2X,p2Y],[p3X,p3Y],[p4X,p4Y],[p5X,p5Y]],arrPoint=[x,y],f(arrPoly,arrPoint))return ctx.restore(),{datapoint:[a.percent,a.data],dataIndex:0,series:a,seriesIndex:r};ctx.restore()}}return null}function m(t){v("plothover",t)}function g(t){v("plotclick",t)}function v(t,i){var s=e.offset(),o=parseInt(i.pageX-s.left),r=parseInt(i.pageY-s.top),a=p(o,r);if(n.grid.autoHighlight)for(var l=0;l<F.length;++l){var c=F[l];c.auto!=t||a&&c.series==a.series||_(c.series)}a&&b(a.series,t);var h={pageX:i.pageX,pageY:i.pageY};S.trigger(t,[h,a])}function b(t,i){"number"==typeof t&&(t=series[t]);var n=w(t);-1==n?(F.push({series:t,auto:i}),e.triggerRedrawOverlay()):i||(F[n].auto=!1)}function _(t){null==t&&(F=[],e.triggerRedrawOverlay()),"number"==typeof t&&(t=series[t]);var i=w(t);-1!=i&&(F.splice(i,1),e.triggerRedrawOverlay())}function w(t){for(var e=0;e<F.length;++e){var i=F[e];if(i.series==t)return e}return-1}function C(t,e){function n(t){t.angle<0||(e.fillStyle="rgba(255, 255, 255, "+s.series.pie.highlight.opacity+")",e.beginPath(),Math.abs(t.angle-2*Math.PI)>1e-9&&e.moveTo(0,0),e.arc(0,0,o,t.startAngle,t.startAngle+t.angle,!1),e.closePath(),e.fill())}var s=t.getOptions(),o=s.series.pie.radius>1?s.series.pie.radius:T*s.series.pie.radius;for(e.save(),e.translate(D,M),e.scale(1,s.series.pie.tilt),i=0;i<F.length;++i)n(F[i].series);d(e),e.restore()}var k=null,S=null,T=null,D=null,M=null,E=0,A=!0,P=10,I=.95,N=0,z=!1,F=[];e.hooks.processOptions.push(s),e.hooks.bindEvents.push(o)}var n={series:{pie:{show:!1,radius:"auto",innerRadius:0,startAngle:1.5,tilt:1,offset:{top:0,left:"auto"},stroke:{color:"#FFF",width:1},label:{show:"auto",formatter:function(t,e){return'<div style="font-size:x-small;text-align:center;padding:2px;color:'+e.color+';">'+t+"<br/>"+Math.round(e.percent)+"%</div>"},radius:1,background:{color:null,opacity:0},threshold:0},combine:{threshold:-1,color:null,label:"Other"},highlight:{opacity:.5}}}};t.plot.plugins.push({init:e,options:n,name:"pie",version:"1.0"})}(jQuery);