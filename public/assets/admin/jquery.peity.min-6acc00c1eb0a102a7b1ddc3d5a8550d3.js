!function(t,e){function i(t,i){var n=e.createElement("canvas");return n.setAttribute("width",t*s),n.setAttribute("height",i*s),1!=s&&n.setAttribute("style","width:"+t+"px;height:"+i+"px"),n}var n=t.fn.peity=function(i,s){return e.createElement("canvas").getContext&&this.each(function(){t(this).change(function(){var e=t.extend({},s),o=this;t.each(e,function(i,n){t.isFunction(n)&&(e[i]=n.call(o))});var r=t(this).html();n.graphers[i].call(this,t.extend({},n.defaults[i],e)),t(this).trigger("chart:changed",r)}).trigger("change")}),this};n.graphers={},n.defaults={},n.add=function(t,e,i){n.graphers[t]=i,n.defaults[t]=e};var s=window.devicePixelRatio||1;n.add("pie",{colours:["#FFF4DD","#FF9900"],delimeter:"/",diameter:16},function(e){var n=t(this),s=n.text().split(e.delimeter),o=parseFloat(s[0]),r=parseFloat(s[1]),s=-Math.PI/2,o=2*o/r*Math.PI,r=i(e.diameter,e.diameter),a=r.getContext("2d"),l=r.width/2;a.beginPath(),a.moveTo(l,l),a.arc(l,l,l,o+s,0==o?2*Math.PI:s,!1),a.fillStyle=e.colours[0],a.fill(),a.beginPath(),a.moveTo(l,l),a.arc(l,l,l,s,o+s,!1),a.fillStyle=e.colours[1],a.fill(),n.wrapInner(t("<span>").hide()).append(r)}),n.add("line",{colour:"#c6d9fd",strokeColour:"#4d89f9",strokeWidth:1,delimeter:",",height:16,max:null,min:0,width:32},function(e){var n=t(this),o=i(e.width,e.height),r=n.text().split(e.delimeter);1==r.length&&r.push(r[0]);var a,l=Math.max.apply(Math,r.concat([e.max])),h=Math.min.apply(Math,r.concat([e.min])),c=o.getContext("2d"),u=o.width,d=o.height,f=u/(r.length-1),l=d/(l-h),p=[];for(c.beginPath(),c.moveTo(0,d+h*l),a=0;a<r.length;a++){var m=a*f,g=d-l*(r[a]-h);p.push({x:m,y:g}),c.lineTo(m,g)}if(c.lineTo(u,d+h*l),c.fillStyle=e.colour,c.fill(),e.strokeWidth){for(c.beginPath(),c.moveTo(0,p[0].y),a=0;a<p.length;a++)c.lineTo(p[a].x,p[a].y);c.lineWidth=e.strokeWidth*s,c.strokeStyle=e.strokeColour,c.stroke()}n.wrapInner(t("<span>").hide()).append(o)}),n.add("bar",{colour:"#4D89F9",delimeter:",",height:16,max:null,min:0,width:32},function(e){var n=t(this),o=n.text().split(e.delimeter),r=Math.max.apply(Math,o.concat([e.max])),a=Math.min.apply(Math,o.concat([e.min])),l=i(e.width,e.height),h=l.getContext("2d"),c=l.height,r=c/(r-a),u=s/2,d=(l.width+u)/o.length;for(h.fillStyle=e.colour,e=0;e<o.length;e++)h.fillRect(e*d,c-r*(o[e]-a),d-u,r*o[e]);n.wrapInner(t("<span>").hide()).append(l)})}(jQuery,document);