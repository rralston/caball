!function(t){t.color={},t.color.make=function(e,i,n,s){var o={};return o.r=e||0,o.g=i||0,o.b=n||0,o.a=null!=s?s:1,o.add=function(t,e){for(var i=0;i<t.length;++i)o[t.charAt(i)]+=e;return o.normalize()},o.scale=function(t,e){for(var i=0;i<t.length;++i)o[t.charAt(i)]*=e;return o.normalize()},o.toString=function(){return o.a>=1?"rgb("+[o.r,o.g,o.b].join(",")+")":"rgba("+[o.r,o.g,o.b,o.a].join(",")+")"},o.normalize=function(){function t(t,e,i){return t>e?t:e>i?i:e}return o.r=t(0,parseInt(o.r),255),o.g=t(0,parseInt(o.g),255),o.b=t(0,parseInt(o.b),255),o.a=t(0,o.a,1),o},o.clone=function(){return t.color.make(o.r,o.b,o.g,o.a)},o.normalize()},t.color.extract=function(e,i){var n;do{if(n=e.css(i).toLowerCase(),""!=n&&"transparent"!=n)break;e=e.parent()}while(!t.nodeName(e.get(0),"body"));return"rgba(0, 0, 0, 0)"==n&&(n="transparent"),t.color.parse(n)},t.color.parse=function(i){var n,s=t.color.make;if(n=/rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(i))return s(parseInt(n[1],10),parseInt(n[2],10),parseInt(n[3],10));if(n=/rgba\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]+(?:\.[0-9]+)?)\s*\)/.exec(i))return s(parseInt(n[1],10),parseInt(n[2],10),parseInt(n[3],10),parseFloat(n[4]));if(n=/rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(i))return s(2.55*parseFloat(n[1]),2.55*parseFloat(n[2]),2.55*parseFloat(n[3]));if(n=/rgba\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\s*\)/.exec(i))return s(2.55*parseFloat(n[1]),2.55*parseFloat(n[2]),2.55*parseFloat(n[3]),parseFloat(n[4]));if(n=/#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(i))return s(parseInt(n[1],16),parseInt(n[2],16),parseInt(n[3],16));if(n=/#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(i))return s(parseInt(n[1]+n[1],16),parseInt(n[2]+n[2],16),parseInt(n[3]+n[3],16));var o=t.trim(i).toLowerCase();return"transparent"==o?s(255,255,255,0):(n=e[o]||[0,0,0],s(n[0],n[1],n[2]))};var e={aqua:[0,255,255],azure:[240,255,255],beige:[245,245,220],black:[0,0,0],blue:[0,0,255],brown:[165,42,42],cyan:[0,255,255],darkblue:[0,0,139],darkcyan:[0,139,139],darkgrey:[169,169,169],darkgreen:[0,100,0],darkkhaki:[189,183,107],darkmagenta:[139,0,139],darkolivegreen:[85,107,47],darkorange:[255,140,0],darkorchid:[153,50,204],darkred:[139,0,0],darksalmon:[233,150,122],darkviolet:[148,0,211],fuchsia:[255,0,255],gold:[255,215,0],green:[0,128,0],indigo:[75,0,130],khaki:[240,230,140],lightblue:[173,216,230],lightcyan:[224,255,255],lightgreen:[144,238,144],lightgrey:[211,211,211],lightpink:[255,182,193],lightyellow:[255,255,224],lime:[0,255,0],magenta:[255,0,255],maroon:[128,0,0],navy:[0,0,128],olive:[128,128,0],orange:[255,165,0],pink:[255,192,203],purple:[128,0,128],violet:[128,0,128],red:[255,0,0],silver:[192,192,192],white:[255,255,255],yellow:[255,255,0]}}(jQuery),function(t){function e(e,s,o,r){function a(t,e){e=[_e].concat(e);for(var i=0;i<t.length;++i)t[i].apply(this,e)}function l(){for(var e=0;e<r.length;++e){var i=r[e];i.init(_e),i.options&&t.extend(!0,re,i.options)}}function c(e){var i;for(t.extend(!0,re,e),null==re.xaxis.color&&(re.xaxis.color=re.grid.color),null==re.yaxis.color&&(re.yaxis.color=re.grid.color),null==re.xaxis.tickColor&&(re.xaxis.tickColor=re.grid.tickColor),null==re.yaxis.tickColor&&(re.yaxis.tickColor=re.grid.tickColor),null==re.grid.borderColor&&(re.grid.borderColor=re.grid.color),null==re.grid.tickColor&&(re.grid.tickColor=t.color.parse(re.grid.color).scale("a",.22).toString()),i=0;i<Math.max(1,re.xaxes.length);++i)re.xaxes[i]=t.extend(!0,{},re.xaxis,re.xaxes[i]);for(i=0;i<Math.max(1,re.yaxes.length);++i)re.yaxes[i]=t.extend(!0,{},re.yaxis,re.yaxes[i]);for(re.xaxis.noTicks&&null==re.xaxis.ticks&&(re.xaxis.ticks=re.xaxis.noTicks),re.yaxis.noTicks&&null==re.yaxis.ticks&&(re.yaxis.ticks=re.yaxis.noTicks),re.x2axis&&(re.xaxes[1]=t.extend(!0,{},re.xaxis,re.x2axis),re.xaxes[1].position="top"),re.y2axis&&(re.yaxes[1]=t.extend(!0,{},re.yaxis,re.y2axis),re.yaxes[1].position="right"),re.grid.coloredAreas&&(re.grid.markings=re.grid.coloredAreas),re.grid.coloredAreasColor&&(re.grid.markingsColor=re.grid.coloredAreasColor),re.lines&&t.extend(!0,re.series.lines,re.lines),re.points&&t.extend(!0,re.series.points,re.points),re.bars&&t.extend(!0,re.series.bars,re.bars),null!=re.shadowSize&&(re.series.shadowSize=re.shadowSize),i=0;i<re.xaxes.length;++i)g(de,i+1).options=re.xaxes[i];for(i=0;i<re.yaxes.length;++i)g(fe,i+1).options=re.yaxes[i];for(var n in be)re.hooks[n]&&re.hooks[n].length&&(be[n]=be[n].concat(re.hooks[n]));a(be.processOptions,[re])}function h(t){oe=u(t),v(),y()}function u(e){for(var i=[],n=0;n<e.length;++n){var s=t.extend(!0,{},re.series);null!=e[n].data?(s.data=e[n].data,delete e[n].data,t.extend(!0,s,e[n]),e[n].data=s.data):s.data=e[n],i.push(s)}return i}function d(t,e){var i=t[e+"axis"];return"object"==typeof i&&(i=i.n),"number"!=typeof i&&(i=1),i}function f(){return t.grep(de.concat(fe),function(t){return t})}function p(t){var e,i,n={};for(e=0;e<de.length;++e)i=de[e],i&&i.used&&(n["x"+i.n]=i.c2p(t.left));for(e=0;e<fe.length;++e)i=fe[e],i&&i.used&&(n["y"+i.n]=i.c2p(t.top));return void 0!==n.x1&&(n.x=n.x1),void 0!==n.y1&&(n.y=n.y1),n}function m(t){var e,i,n,s={};for(e=0;e<de.length;++e)if(i=de[e],i&&i.used&&(n="x"+i.n,null==t[n]&&1==i.n&&(n="x"),null!=t[n])){s.left=i.p2c(t[n]);break}for(e=0;e<fe.length;++e)if(i=fe[e],i&&i.used&&(n="y"+i.n,null==t[n]&&1==i.n&&(n="y"),null!=t[n])){s.top=i.p2c(t[n]);break}return s}function g(e,i){return e[i-1]||(e[i-1]={n:i,direction:e==de?"x":"y",options:t.extend(!0,{},e==de?re.xaxis:re.yaxis)}),e[i-1]}function v(){var e,i=oe.length,n=[],s=[];for(e=0;e<oe.length;++e){var o=oe[e].color;null!=o&&(--i,"number"==typeof o?s.push(o):n.push(t.color.parse(oe[e].color)))}for(e=0;e<s.length;++e)i=Math.max(i,s[e]+1);var r=[],a=0;for(e=0;r.length<i;){var l;l=re.colors.length==e?t.color.make(100,100,100):t.color.parse(re.colors[e]);var c=1==a%2?-1:1;l.scale("rgb",1+.2*c*Math.ceil(a/2)),r.push(l),++e,e>=re.colors.length&&(e=0,++a)}var h,u=0;for(e=0;e<oe.length;++e){if(h=oe[e],null==h.color?(h.color=r[u].toString(),++u):"number"==typeof h.color&&(h.color=r[h.color].toString()),null==h.lines.show){var f,p=!0;for(f in h)if(h[f]&&h[f].show){p=!1;break}p&&(h.lines.show=!0)}h.xaxis=g(de,d(h,"x")),h.yaxis=g(fe,d(h,"y"))}}function y(){function e(t,e,i){e<t.datamin&&e!=-g&&(t.datamin=e),i>t.datamax&&i!=g&&(t.datamax=i)}var i,n,s,o,r,l,c,h,u,d,p=Number.POSITIVE_INFINITY,m=Number.NEGATIVE_INFINITY,g=Number.MAX_VALUE;for(t.each(f(),function(t,e){e.datamin=p,e.datamax=m,e.used=!1}),i=0;i<oe.length;++i)r=oe[i],r.datapoints={points:[]},a(be.processRawData,[r,r.data,r.datapoints]);for(i=0;i<oe.length;++i){r=oe[i];var v=r.data,y=r.datapoints.format;if(y||(y=[],y.push({x:!0,number:!0,required:!0}),y.push({y:!0,number:!0,required:!0}),(r.bars.show||r.lines.show&&r.lines.fill)&&(y.push({y:!0,number:!0,required:!1,defaultValue:0}),r.bars.horizontal&&(delete y[y.length-1].y,y[y.length-1].x=!0)),r.datapoints.format=y),null==r.datapoints.pointsize)for(r.datapoints.pointsize=y.length,c=r.datapoints.pointsize,l=r.datapoints.points,insertSteps=r.lines.show&&r.lines.steps,r.xaxis.used=r.yaxis.used=!0,n=s=0;n<v.length;++n,s+=c){d=v[n];var b=null==d;if(!b)for(o=0;c>o;++o)h=d[o],u=y[o],u&&(u.number&&null!=h&&(h=+h,isNaN(h)?h=null:1/0==h?h=g:h==-1/0&&(h=-g)),null==h&&(u.required&&(b=!0),null!=u.defaultValue&&(h=u.defaultValue))),l[s+o]=h;if(b)for(o=0;c>o;++o)h=l[s+o],null!=h&&(u=y[o],u.x&&e(r.xaxis,h,h),u.y&&e(r.yaxis,h,h)),l[s+o]=null;else if(insertSteps&&s>0&&null!=l[s-c]&&l[s-c]!=l[s]&&l[s-c+1]!=l[s+1]){for(o=0;c>o;++o)l[s+c+o]=l[s+o];l[s+1]=l[s-c+1],s+=c}}}for(i=0;i<oe.length;++i)r=oe[i],a(be.processDatapoints,[r,r.datapoints]);for(i=0;i<oe.length;++i){r=oe[i],l=r.datapoints.points,c=r.datapoints.pointsize;var _=p,w=p,x=m,C=m;for(n=0;n<l.length;n+=c)if(null!=l[n])for(o=0;c>o;++o)h=l[n+o],u=y[o],u&&h!=g&&h!=-g&&(u.x&&(_>h&&(_=h),h>x&&(x=h)),u.y&&(w>h&&(w=h),h>C&&(C=h)));if(r.bars.show){var k="left"==r.bars.align?0:-r.bars.barWidth/2;r.bars.horizontal?(w+=k,C+=k+r.bars.barWidth):(_+=k,x+=k+r.bars.barWidth)}e(r.xaxis,_,x),e(r.yaxis,w,C)}t.each(f(),function(t,e){e.datamin==p&&(e.datamin=null),e.datamax==m&&(e.datamax=null)})}function b(i,n){var s=document.createElement("canvas");return s.className=n,s.width=me,s.height=ge,i||t(s).css({position:"absolute",left:0,top:0}),t(s).appendTo(e),s.getContext||(s=window.G_vmlCanvasManager.initElement(s)),s.getContext("2d").save(),s}function _(){if(me=e.width(),ge=e.height(),0>=me||0>=ge)throw"Invalid dimensions for plot, width = "+me+", height = "+ge}function w(t){t.width!=me&&(t.width=me),t.height!=ge&&(t.height=ge);var e=t.getContext("2d");e.restore(),e.save()}function x(){var i,n=e.children("canvas.base"),s=e.children("canvas.overlay");0==n.length||0==s?(e.html(""),e.css({padding:0}),"static"==e.css("position")&&e.css("position","relative"),_(),ae=b(!0,"base"),le=b(!1,"overlay"),i=!1):(ae=n.get(0),le=s.get(0),i=!0),he=ae.getContext("2d"),ue=le.getContext("2d"),ce=t([le,ae]),i&&(e.data("plot").shutdown(),_e.resize(),ue.clearRect(0,0,me,ge),ce.unbind(),e.children().not([ae,le]).remove()),e.data("plot",_e)}function C(){re.grid.hoverable&&(ce.mousemove(Y),ce.mouseleave(X)),re.grid.clickable&&ce.click(Q),a(be.bindEvents,[ce])}function k(){xe&&clearTimeout(xe),ce.unbind("mousemove",Y),ce.unbind("mouseleave",X),ce.unbind("click",Q),a(be.shutdown,[ce])}function S(t){function e(t){return t}var i,n,s=t.options.transform||e,o=t.options.inverseTransform;"x"==t.direction?(i=t.scale=ve/Math.abs(s(t.max)-s(t.min)),n=Math.min(s(t.max),s(t.min))):(i=t.scale=ye/Math.abs(s(t.max)-s(t.min)),i=-i,n=Math.max(s(t.max),s(t.min))),t.p2c=s==e?function(t){return(t-n)*i}:function(t){return(s(t)-n)*i},t.c2p=o?function(t){return o(n+t/i)}:function(t){return n+t/i}}function T(i){function n(n,s){return t('<div style="position:absolute;top:-10000px;'+s+'font-size:smaller"><div class="'+i.direction+"Axis "+i.direction+i.n+'Axis">'+n.join("")+"</div></div>").appendTo(e)}var s,o,r,a=i.options,l=i.ticks||[],c=[],h=a.labelWidth,u=a.labelHeight;if("x"==i.direction){if(null==h&&(h=Math.floor(me/(l.length>0?l.length:1))),null==u){for(c=[],s=0;s<l.length;++s)o=l[s].label,o&&c.push('<div class="tickLabel" style="float:left;width:'+h+'px">'+o+"</div>");c.length>0&&(c.push('<div style="clear:left"></div>'),r=n(c,"width:10000px;"),u=r.height(),r.remove())}}else if(null==h||null==u){for(s=0;s<l.length;++s)o=l[s].label,o&&c.push('<div class="tickLabel">'+o+"</div>");c.length>0&&(r=n(c,""),null==h&&(h=r.children().width()),null==u&&(u=r.find("div.tickLabel").height()),r.remove())}null==h&&(h=0),null==u&&(u=0),i.labelWidth=h,i.labelHeight=u}function D(e){var i=e.labelWidth,n=e.labelHeight,s=e.options.position,o=e.options.tickLength,r=re.grid.axisMargin,a=re.grid.labelMargin,l="x"==e.direction?de:fe,c=t.grep(l,function(t){return t&&t.options.position==s&&t.reserveSpace});t.inArray(e,c)==c.length-1&&(r=0),null==o&&(o="full");var h=t.grep(l,function(t){return t&&t.reserveSpace}),u=0==t.inArray(e,h);u||"full"!=o||(o=5),isNaN(+o)||(a+=+o),"x"==e.direction?(n+=a,"bottom"==s?(pe.bottom+=n+r,e.box={top:ge-pe.bottom,height:n}):(e.box={top:pe.top+r,height:n},pe.top+=n+r)):(i+=a,"left"==s?(e.box={left:pe.left+r,width:i},pe.left+=i+r):(pe.right+=i+r,e.box={left:me-pe.right,width:i})),e.position=s,e.tickLength=o,e.box.padding=a,e.innermost=u}function M(t){"x"==t.direction?(t.box.left=pe.left,t.box.width=ve):(t.box.top=pe.top,t.box.height=ye)}function E(){var e,i=f();if(t.each(i,function(t,e){e.show=e.options.show,null==e.show&&(e.show=e.used),e.reserveSpace=e.show||e.options.reserveSpace,A(e)}),allocatedAxes=t.grep(i,function(t){return t.reserveSpace}),pe.left=pe.right=pe.top=pe.bottom=0,re.grid.show){for(t.each(allocatedAxes,function(t,e){P(e),I(e),N(e,e.ticks),T(e)}),e=allocatedAxes.length-1;e>=0;--e)D(allocatedAxes[e]);var n=re.grid.minBorderMargin;if(null==n)for(n=0,e=0;e<oe.length;++e)n=Math.max(n,oe[e].points.radius+oe[e].points.lineWidth/2);for(var s in pe)pe[s]+=re.grid.borderWidth,pe[s]=Math.max(n,pe[s])}ve=me-pe.left-pe.right,ye=ge-pe.bottom-pe.top,t.each(i,function(t,e){S(e)}),re.grid.show&&(t.each(allocatedAxes,function(t,e){M(e)}),O()),U()}function A(t){var e=t.options,i=+(null!=e.min?e.min:t.datamin),n=+(null!=e.max?e.max:t.datamax),s=n-i;if(0==s){var o=0==n?1:.01;null==e.min&&(i-=o),(null==e.max||null!=e.min)&&(n+=o)}else{var r=e.autoscaleMargin;null!=r&&(null==e.min&&(i-=s*r,0>i&&null!=t.datamin&&t.datamin>=0&&(i=0)),null==e.max&&(n+=s*r,n>0&&null!=t.datamax&&t.datamax<=0&&(n=0)))}t.min=i,t.max=n}function P(e){var i,s=e.options;i="number"==typeof s.ticks&&s.ticks>0?s.ticks:.3*Math.sqrt("x"==e.direction?me:ge);var o,r,a,l,c,h,u,d=(e.max-e.min)/i;if("time"==s.mode){var f={second:1e3,minute:6e4,hour:36e5,day:864e5,month:2592e6,year:1e3*525949.2*60},p=[[1,"second"],[2,"second"],[5,"second"],[10,"second"],[30,"second"],[1,"minute"],[2,"minute"],[5,"minute"],[10,"minute"],[30,"minute"],[1,"hour"],[2,"hour"],[4,"hour"],[8,"hour"],[12,"hour"],[1,"day"],[2,"day"],[3,"day"],[.25,"month"],[.5,"month"],[1,"month"],[2,"month"],[3,"month"],[6,"month"],[1,"year"]],m=0;null!=s.minTickSize&&(m="number"==typeof s.tickSize?s.tickSize:s.minTickSize[0]*f[s.minTickSize[1]]);for(var c=0;c<p.length-1&&!(d<(p[c][0]*f[p[c][1]]+p[c+1][0]*f[p[c+1][1]])/2&&p[c][0]*f[p[c][1]]>=m);++c);o=p[c][0],a=p[c][1],"year"==a&&(h=Math.pow(10,Math.floor(Math.log(d/f.year)/Math.LN10)),u=d/f.year/h,o=1.5>u?1:3>u?2:7.5>u?5:10,o*=h),e.tickSize=s.tickSize||[o,a],r=function(t){var e=[],i=t.tickSize[0],s=t.tickSize[1],o=new Date(t.min),r=i*f[s];"second"==s&&o.setUTCSeconds(n(o.getUTCSeconds(),i)),"minute"==s&&o.setUTCMinutes(n(o.getUTCMinutes(),i)),"hour"==s&&o.setUTCHours(n(o.getUTCHours(),i)),"month"==s&&o.setUTCMonth(n(o.getUTCMonth(),i)),"year"==s&&o.setUTCFullYear(n(o.getUTCFullYear(),i)),o.setUTCMilliseconds(0),r>=f.minute&&o.setUTCSeconds(0),r>=f.hour&&o.setUTCMinutes(0),r>=f.day&&o.setUTCHours(0),r>=4*f.day&&o.setUTCDate(1),r>=f.year&&o.setUTCMonth(0);var a,l=0,c=Number.NaN;do if(a=c,c=o.getTime(),e.push(c),"month"==s)if(1>i){o.setUTCDate(1);var h=o.getTime();o.setUTCMonth(o.getUTCMonth()+1);var u=o.getTime();o.setTime(c+l*f.hour+(u-h)*i),l=o.getUTCHours(),o.setUTCHours(0)}else o.setUTCMonth(o.getUTCMonth()+i);else"year"==s?o.setUTCFullYear(o.getUTCFullYear()+i):o.setTime(c+r);while(c<t.max&&c!=a);return e},l=function(e,i){var n=new Date(e);if(null!=s.timeformat)return t.plot.formatDate(n,s.timeformat,s.monthNames);var o=i.tickSize[0]*f[i.tickSize[1]],r=i.max-i.min,a=s.twelveHourClock?" %p":"";return fmt=o<f.minute?"%h:%M:%S"+a:o<f.day?r<2*f.day?"%h:%M"+a:"%b %d %h:%M"+a:o<f.month?"%b %d":o<f.year?r<f.year?"%b":"%b %y":"%y",t.plot.formatDate(n,fmt,s.monthNames)}}else{var g=s.tickDecimals,v=-Math.floor(Math.log(d)/Math.LN10);null!=g&&v>g&&(v=g),h=Math.pow(10,-v),u=d/h,1.5>u?o=1:3>u?(o=2,u>2.25&&(null==g||g>=v+1)&&(o=2.5,++v)):o=7.5>u?5:10,o*=h,null!=s.minTickSize&&o<s.minTickSize&&(o=s.minTickSize),e.tickDecimals=Math.max(0,null!=g?g:v),e.tickSize=s.tickSize||o,r=function(t){var e,i=[],s=n(t.min,t.tickSize),o=0,r=Number.NaN;do e=r,r=s+o*t.tickSize,i.push(r),++o;while(r<t.max&&r!=e);return i},l=function(t,e){return t.toFixed(e.tickDecimals)}}if(null!=s.alignTicksWithAxis){var y=("x"==e.direction?de:fe)[s.alignTicksWithAxis-1];if(y&&y.used&&y!=e){var b=r(e);if(b.length>0&&(null==s.min&&(e.min=Math.min(e.min,b[0])),null==s.max&&b.length>1&&(e.max=Math.max(e.max,b[b.length-1]))),r=function(t){var e,i,n=[];for(i=0;i<y.ticks.length;++i)e=(y.ticks[i].v-y.min)/(y.max-y.min),e=t.min+e*(t.max-t.min),n.push(e);return n},"time"!=e.mode&&null==s.tickDecimals){var _=Math.max(0,-Math.floor(Math.log(d)/Math.LN10)+1),w=r(e);w.length>1&&/\..*0$/.test((w[1]-w[0]).toFixed(_))||(e.tickDecimals=_)}}}e.tickGenerator=r,e.tickFormatter=t.isFunction(s.tickFormatter)?function(t,e){return""+s.tickFormatter(t,e)}:l}function I(e){var i=e.options.ticks,n=[];null==i||"number"==typeof i&&i>0?n=e.tickGenerator(e):i&&(n=t.isFunction(i)?i({min:e.min,max:e.max}):i);var s,o;for(e.ticks=[],s=0;s<n.length;++s){var r=null,a=n[s];"object"==typeof a?(o=+a[0],a.length>1&&(r=a[1])):o=+a,null==r&&(r=e.tickFormatter(o,e)),isNaN(o)||e.ticks.push({v:o,label:r})}}function N(t,e){t.options.autoscaleMargin&&e.length>0&&(null==t.options.min&&(t.min=Math.min(t.min,e[0].v)),null==t.options.max&&e.length>1&&(t.max=Math.max(t.max,e[e.length-1].v)))}function z(){he.clearRect(0,0,me,ge);var t=re.grid;t.show&&t.backgroundColor&&H(),t.show&&!t.aboveData&&$();for(var e=0;e<oe.length;++e)a(be.drawSeries,[he,oe[e]]),W(oe[e]);a(be.draw,[he]),t.show&&t.aboveData&&$()}function F(t,e){var n,s,o,r,a=f();for(i=0;i<a.length;++i)if(n=a[i],n.direction==e&&(r=e+n.n+"axis",t[r]||1!=n.n||(r=e+"axis"),t[r])){s=t[r].from,o=t[r].to;break}if(t[r]||(n="x"==e?de[0]:fe[0],s=t[e+"1"],o=t[e+"2"]),null!=s&&null!=o&&s>o){var l=s;s=o,o=l}return{from:s,to:o,axis:n}}function H(){he.save(),he.translate(pe.left,pe.top),he.fillStyle=se(re.grid.backgroundColor,ye,0,"rgba(255, 255, 255, 0)"),he.fillRect(0,0,ve,ye),he.restore()}function $(){var e;he.save(),he.translate(pe.left,pe.top);var i=re.grid.markings;if(i){if(t.isFunction(i)){var n=_e.getAxes();n.xmin=n.xaxis.min,n.xmax=n.xaxis.max,n.ymin=n.yaxis.min,n.ymax=n.yaxis.max,i=i(n)}for(e=0;e<i.length;++e){var s=i[e],o=F(s,"x"),r=F(s,"y");null==o.from&&(o.from=o.axis.min),null==o.to&&(o.to=o.axis.max),null==r.from&&(r.from=r.axis.min),null==r.to&&(r.to=r.axis.max),o.to<o.axis.min||o.from>o.axis.max||r.to<r.axis.min||r.from>r.axis.max||(o.from=Math.max(o.from,o.axis.min),o.to=Math.min(o.to,o.axis.max),r.from=Math.max(r.from,r.axis.min),r.to=Math.min(r.to,r.axis.max),(o.from!=o.to||r.from!=r.to)&&(o.from=o.axis.p2c(o.from),o.to=o.axis.p2c(o.to),r.from=r.axis.p2c(r.from),r.to=r.axis.p2c(r.to),o.from==o.to||r.from==r.to?(he.beginPath(),he.strokeStyle=s.color||re.grid.markingsColor,he.lineWidth=s.lineWidth||re.grid.markingsLineWidth,he.moveTo(o.from,r.from),he.lineTo(o.to,r.to),he.stroke()):(he.fillStyle=s.color||re.grid.markingsColor,he.fillRect(o.from,r.to,o.to-o.from,r.from-r.to))))}}for(var n=f(),a=re.grid.borderWidth,l=0;l<n.length;++l){var c,h,u,d,p=n[l],m=p.box,g=p.tickLength;if(p.show&&0!=p.ticks.length){for(he.strokeStyle=p.options.tickColor||t.color.parse(p.options.color).scale("a",.22).toString(),he.lineWidth=1,"x"==p.direction?(c=0,h="full"==g?"top"==p.position?0:ye:m.top-pe.top+("top"==p.position?m.height:0)):(h=0,c="full"==g?"left"==p.position?0:ve:m.left-pe.left+("left"==p.position?m.width:0)),p.innermost||(he.beginPath(),u=d=0,"x"==p.direction?u=ve:d=ye,1==he.lineWidth&&(c=Math.floor(c)+.5,h=Math.floor(h)+.5),he.moveTo(c,h),he.lineTo(c+u,h+d),he.stroke()),he.beginPath(),e=0;e<p.ticks.length;++e){var v=p.ticks[e].v;u=d=0,v<p.min||v>p.max||"full"==g&&a>0&&(v==p.min||v==p.max)||("x"==p.direction?(c=p.p2c(v),d="full"==g?-ye:g,"top"==p.position&&(d=-d)):(h=p.p2c(v),u="full"==g?-ve:g,"left"==p.position&&(u=-u)),1==he.lineWidth&&("x"==p.direction?c=Math.floor(c)+.5:h=Math.floor(h)+.5),he.moveTo(c,h),he.lineTo(c+u,h+d))}he.stroke()}}a&&(he.lineWidth=a,he.strokeStyle=re.grid.borderColor,he.strokeRect(-a/2,-a/2,ve+a,ye+a)),he.restore()}function O(){e.find(".tickLabels").remove();for(var t=['<div class="tickLabels" style="font-size:smaller">'],i=f(),n=0;n<i.length;++n){var s=i[n],o=s.box;if(s.show){t.push('<div class="'+s.direction+"Axis "+s.direction+s.n+'Axis" style="color:'+s.options.color+'">');for(var r=0;r<s.ticks.length;++r){var a=s.ticks[r];if(!(!a.label||a.v<s.min||a.v>s.max)){var l,c={};"x"==s.direction?(l="center",c.left=Math.round(pe.left+s.p2c(a.v)-s.labelWidth/2),"bottom"==s.position?c.top=o.top+o.padding:c.bottom=ge-(o.top+o.height-o.padding)):(c.top=Math.round(pe.top+s.p2c(a.v)-s.labelHeight/2),"left"==s.position?(c.right=me-(o.left+o.width-o.padding),l="right"):(c.left=o.left+o.padding,l="left")),c.width=s.labelWidth;var h=["position:absolute","text-align:"+l];for(var u in c)h.push(u+":"+c[u]+"px");t.push('<div class="tickLabel" style="'+h.join(";")+'">'+a.label+"</div>")}}t.push("</div>")}}t.push("</div>"),e.append(t.join(""))}function W(t){t.lines.show&&j(t),t.bars.show&&B(t),t.points.show&&L(t)}function j(t){function e(t,e,i,n,s){var o=t.points,r=t.pointsize,a=null,l=null;he.beginPath();for(var c=r;c<o.length;c+=r){var h=o[c-r],u=o[c-r+1],d=o[c],f=o[c+1];if(null!=h&&null!=d){if(f>=u&&u<s.min){if(f<s.min)continue;h=(s.min-u)/(f-u)*(d-h)+h,u=s.min}else if(u>=f&&f<s.min){if(u<s.min)continue;d=(s.min-u)/(f-u)*(d-h)+h,f=s.min}if(u>=f&&u>s.max){if(f>s.max)continue;h=(s.max-u)/(f-u)*(d-h)+h,u=s.max}else if(f>=u&&f>s.max){if(u>s.max)continue;d=(s.max-u)/(f-u)*(d-h)+h,f=s.max}if(d>=h&&h<n.min){if(d<n.min)continue;u=(n.min-h)/(d-h)*(f-u)+u,h=n.min}else if(h>=d&&d<n.min){if(h<n.min)continue;f=(n.min-h)/(d-h)*(f-u)+u,d=n.min}if(h>=d&&h>n.max){if(d>n.max)continue;u=(n.max-h)/(d-h)*(f-u)+u,h=n.max}else if(d>=h&&d>n.max){if(h>n.max)continue;f=(n.max-h)/(d-h)*(f-u)+u,d=n.max}(h!=a||u!=l)&&he.moveTo(n.p2c(h)+e,s.p2c(u)+i),a=d,l=f,he.lineTo(n.p2c(d)+e,s.p2c(f)+i)}}he.stroke()}function i(t,e,i){for(var n=t.points,s=t.pointsize,o=Math.min(Math.max(0,i.min),i.max),r=0,a=!1,l=1,c=0,h=0;;){if(s>0&&r>n.length+s)break;r+=s;var u=n[r-s],d=n[r-s+l],f=n[r],p=n[r+l];if(a){if(s>0&&null!=u&&null==f){h=r,s=-s,l=2;continue}if(0>s&&r==c+s){he.fill(),a=!1,s=-s,l=1,r=c=h+s;continue}}if(null!=u&&null!=f){if(f>=u&&u<e.min){if(f<e.min)continue;d=(e.min-u)/(f-u)*(p-d)+d,u=e.min}else if(u>=f&&f<e.min){if(u<e.min)continue;p=(e.min-u)/(f-u)*(p-d)+d,f=e.min}if(u>=f&&u>e.max){if(f>e.max)continue;d=(e.max-u)/(f-u)*(p-d)+d,u=e.max}else if(f>=u&&f>e.max){if(u>e.max)continue;p=(e.max-u)/(f-u)*(p-d)+d,f=e.max}if(a||(he.beginPath(),he.moveTo(e.p2c(u),i.p2c(o)),a=!0),d>=i.max&&p>=i.max)he.lineTo(e.p2c(u),i.p2c(i.max)),he.lineTo(e.p2c(f),i.p2c(i.max));else if(d<=i.min&&p<=i.min)he.lineTo(e.p2c(u),i.p2c(i.min)),he.lineTo(e.p2c(f),i.p2c(i.min));else{var m=u,g=f;p>=d&&d<i.min&&p>=i.min?(u=(i.min-d)/(p-d)*(f-u)+u,d=i.min):d>=p&&p<i.min&&d>=i.min&&(f=(i.min-d)/(p-d)*(f-u)+u,p=i.min),d>=p&&d>i.max&&p<=i.max?(u=(i.max-d)/(p-d)*(f-u)+u,d=i.max):p>=d&&p>i.max&&d<=i.max&&(f=(i.max-d)/(p-d)*(f-u)+u,p=i.max),u!=m&&he.lineTo(e.p2c(m),i.p2c(d)),he.lineTo(e.p2c(u),i.p2c(d)),he.lineTo(e.p2c(f),i.p2c(p)),f!=g&&(he.lineTo(e.p2c(f),i.p2c(p)),he.lineTo(e.p2c(g),i.p2c(p)))}}}}he.save(),he.translate(pe.left,pe.top),he.lineJoin="round";var n=t.lines.lineWidth,s=t.shadowSize;if(n>0&&s>0){he.lineWidth=s,he.strokeStyle="rgba(0,0,0,0.1)";var o=Math.PI/18;e(t.datapoints,Math.sin(o)*(n/2+s/2),Math.cos(o)*(n/2+s/2),t.xaxis,t.yaxis),he.lineWidth=s/2,e(t.datapoints,Math.sin(o)*(n/2+s/4),Math.cos(o)*(n/2+s/4),t.xaxis,t.yaxis)}he.lineWidth=n,he.strokeStyle=t.color;var r=q(t.lines,t.color,0,ye);r&&(he.fillStyle=r,i(t.datapoints,t.xaxis,t.yaxis)),n>0&&e(t.datapoints,0,0,t.xaxis,t.yaxis),he.restore()}function L(t){function e(t,e,i,n,s,o,r,a){for(var l=t.points,c=t.pointsize,h=0;h<l.length;h+=c){var u=l[h],d=l[h+1];null==u||u<o.min||u>o.max||d<r.min||d>r.max||(he.beginPath(),u=o.p2c(u),d=r.p2c(d)+n,"circle"==a?he.arc(u,d,e,0,s?Math.PI:2*Math.PI,!1):a(he,u,d,e,s),he.closePath(),i&&(he.fillStyle=i,he.fill()),he.stroke())}}he.save(),he.translate(pe.left,pe.top);var i=t.points.lineWidth,n=t.shadowSize,s=t.points.radius,o=t.points.symbol;if(i>0&&n>0){var r=n/2;he.lineWidth=r,he.strokeStyle="rgba(0,0,0,0.1)",e(t.datapoints,s,null,r+r/2,!0,t.xaxis,t.yaxis,o),he.strokeStyle="rgba(0,0,0,0.2)",e(t.datapoints,s,null,r/2,!0,t.xaxis,t.yaxis,o)}he.lineWidth=i,he.strokeStyle=t.color,e(t.datapoints,s,q(t.points,t.color),0,!1,t.xaxis,t.yaxis,o),he.restore()}function R(t,e,i,n,s,o,r,a,l,c,h,u){var d,f,p,m,g,v,y,b,_;h?(b=v=y=!0,g=!1,d=i,f=t,m=e+n,p=e+s,d>f&&(_=f,f=d,d=_,g=!0,v=!1)):(g=v=y=!0,b=!1,d=t+n,f=t+s,p=i,m=e,p>m&&(_=m,m=p,p=_,b=!0,y=!1)),f<a.min||d>a.max||m<l.min||p>l.max||(d<a.min&&(d=a.min,g=!1),f>a.max&&(f=a.max,v=!1),p<l.min&&(p=l.min,b=!1),m>l.max&&(m=l.max,y=!1),d=a.p2c(d),p=l.p2c(p),f=a.p2c(f),m=l.p2c(m),r&&(c.beginPath(),c.moveTo(d,p),c.lineTo(d,m),c.lineTo(f,m),c.lineTo(f,p),c.fillStyle=r(p,m),c.fill()),u>0&&(g||v||y||b)&&(c.beginPath(),c.moveTo(d,p+o),g?c.lineTo(d,m+o):c.moveTo(d,m+o),y?c.lineTo(f,m+o):c.moveTo(f,m+o),v?c.lineTo(f,p+o):c.moveTo(f,p+o),b?c.lineTo(d,p+o):c.moveTo(d,p+o),c.stroke()))}function B(t){function e(e,i,n,s,o,r,a){for(var l=e.points,c=e.pointsize,h=0;h<l.length;h+=c)null!=l[h]&&R(l[h],l[h+1],l[h+2],i,n,s,o,r,a,he,t.bars.horizontal,t.bars.lineWidth)}he.save(),he.translate(pe.left,pe.top),he.lineWidth=t.bars.lineWidth,he.strokeStyle=t.color;var i="left"==t.bars.align?0:-t.bars.barWidth/2,n=t.bars.fill?function(e,i){return q(t.bars,t.color,e,i)}:null;e(t.datapoints,i,i+t.bars.barWidth,0,n,t.xaxis,t.yaxis),he.restore()}function q(e,i,n,s){var o=e.fill;if(!o)return null;if(e.fillColor)return se(e.fillColor,n,s,i);var r=t.color.parse(i);return r.a="number"==typeof o?o:.4,r.normalize(),r.toString()}function U(){if(e.find(".legend").remove(),re.legend.show){for(var i,n,s=[],o=!1,r=re.legend.labelFormatter,a=0;a<oe.length;++a)i=oe[a],n=i.label,n&&(0==a%re.legend.noColumns&&(o&&s.push("</tr>"),s.push("<tr>"),o=!0),r&&(n=r(n,i)),s.push('<td class="legendColorBox"><div style="border:1px solid '+re.legend.labelBoxBorderColor+';padding:1px"><div style="width:4px;height:0;border:5px solid '+i.color+';overflow:hidden"></div></div></td><td class="legendLabel">'+n+"</td>"));if(o&&s.push("</tr>"),0!=s.length){var l='<table style="font-size:smaller;color:'+re.grid.color+'">'+s.join("")+"</table>";if(null!=re.legend.container)t(re.legend.container).html(l);else{var c="",h=re.legend.position,u=re.legend.margin;null==u[0]&&(u=[u,u]),"n"==h.charAt(0)?c+="top:"+(u[1]+pe.top)+"px;":"s"==h.charAt(0)&&(c+="bottom:"+(u[1]+pe.bottom)+"px;"),"e"==h.charAt(1)?c+="right:"+(u[0]+pe.right)+"px;":"w"==h.charAt(1)&&(c+="left:"+(u[0]+pe.left)+"px;");var d=t('<div class="legend">'+l.replace('style="','style="position:absolute;'+c+";")+"</div>").appendTo(e);if(0!=re.legend.backgroundOpacity){var f=re.legend.backgroundColor;null==f&&(f=re.grid.backgroundColor,f=f&&"string"==typeof f?t.color.parse(f):t.color.extract(d,"background-color"),f.a=1,f=f.toString());var p=d.children();t('<div style="position:absolute;width:'+p.width()+"px;height:"+p.height()+"px;"+c+"background-color:"+f+';"> </div>').prependTo(d).css("opacity",re.legend.backgroundOpacity)}}}}}function V(t,e,i){var n,s,o=re.grid.mouseActiveRadius,r=o*o+1,a=null;for(n=oe.length-1;n>=0;--n)if(i(oe[n])){var l=oe[n],c=l.xaxis,h=l.yaxis,u=l.datapoints.points,d=l.datapoints.pointsize,f=c.c2p(t),p=h.c2p(e),m=o/c.scale,g=o/h.scale;if(c.options.inverseTransform&&(m=Number.MAX_VALUE),h.options.inverseTransform&&(g=Number.MAX_VALUE),l.lines.show||l.points.show)for(s=0;s<u.length;s+=d){var v=u[s],y=u[s+1];if(null!=v&&!(v-f>m||-m>v-f||y-p>g||-g>y-p)){var b=Math.abs(c.p2c(v)-t),_=Math.abs(h.p2c(y)-e),w=b*b+_*_;r>w&&(r=w,a=[n,s/d])}}if(l.bars.show&&!a){var x="left"==l.bars.align?0:-l.bars.barWidth/2,C=x+l.bars.barWidth;for(s=0;s<u.length;s+=d){var v=u[s],y=u[s+1],k=u[s+2];null!=v&&(oe[n].bars.horizontal?f<=Math.max(k,v)&&f>=Math.min(k,v)&&p>=y+x&&y+C>=p:f>=v+x&&v+C>=f&&p>=Math.min(k,y)&&p<=Math.max(k,y))&&(a=[n,s/d])}}}return a?(n=a[0],s=a[1],d=oe[n].datapoints.pointsize,{datapoint:oe[n].datapoints.points.slice(s*d,(s+1)*d),dataIndex:s,series:oe[n],seriesIndex:n}):null}function Y(t){re.grid.hoverable&&K("plothover",t,function(t){return 0!=t.hoverable})}function X(t){re.grid.hoverable&&K("plothover",t,function(){return!1})}function Q(t){K("plotclick",t,function(t){return 0!=t.clickable})}function K(t,i,n){var s=ce.offset(),o=i.pageX-s.left-pe.left,r=i.pageY-s.top-pe.top,a=p({left:o,top:r});a.pageX=i.pageX,a.pageY=i.pageY;var l=V(o,r,n);if(l&&(l.pageX=parseInt(l.series.xaxis.p2c(l.datapoint[0])+s.left+pe.left),l.pageY=parseInt(l.series.yaxis.p2c(l.datapoint[1])+s.top+pe.top)),re.grid.autoHighlight){for(var c=0;c<we.length;++c){var h=we[c];h.auto!=t||l&&h.series==l.series&&h.point[0]==l.datapoint[0]&&h.point[1]==l.datapoint[1]||te(h.series,h.point)}l&&Z(l.series,l.datapoint,t)}e.trigger(t,[a,l])}function G(){xe||(xe=setTimeout(J,30))}function J(){xe=null,ue.save(),ue.clearRect(0,0,me,ge),ue.translate(pe.left,pe.top);var t,e;for(t=0;t<we.length;++t)e=we[t],e.series.bars.show?ne(e.series,e.point):ie(e.series,e.point);ue.restore(),a(be.drawOverlay,[ue])}function Z(t,e,i){if("number"==typeof t&&(t=oe[t]),"number"==typeof e){var n=t.datapoints.pointsize;e=t.datapoints.points.slice(n*e,n*(e+1))}var s=ee(t,e);-1==s?(we.push({series:t,point:e,auto:i}),G()):i||(we[s].auto=!1)}function te(t,e){null==t&&null==e&&(we=[],G()),"number"==typeof t&&(t=oe[t]),"number"==typeof e&&(e=t.data[e]);var i=ee(t,e);-1!=i&&(we.splice(i,1),G())}function ee(t,e){for(var i=0;i<we.length;++i){var n=we[i];if(n.series==t&&n.point[0]==e[0]&&n.point[1]==e[1])return i}return-1}function ie(e,i){var n=i[0],s=i[1],o=e.xaxis,r=e.yaxis;if(!(n<o.min||n>o.max||s<r.min||s>r.max)){var a=e.points.radius+e.points.lineWidth/2;ue.lineWidth=a,ue.strokeStyle=t.color.parse(e.color).scale("a",.5).toString();var l=1.5*a,n=o.p2c(n),s=r.p2c(s);ue.beginPath(),"circle"==e.points.symbol?ue.arc(n,s,l,0,2*Math.PI,!1):e.points.symbol(ue,n,s,l,!1),ue.closePath(),ue.stroke()}}function ne(e,i){ue.lineWidth=e.bars.lineWidth,ue.strokeStyle=t.color.parse(e.color).scale("a",.5).toString();var n=t.color.parse(e.color).scale("a",.5).toString(),s="left"==e.bars.align?0:-e.bars.barWidth/2;R(i[0],i[1],i[2]||0,s,s+e.bars.barWidth,0,function(){return n},e.xaxis,e.yaxis,ue,e.bars.horizontal,e.bars.lineWidth)}function se(e,i,n,s){if("string"==typeof e)return e;for(var o=he.createLinearGradient(0,n,0,i),r=0,a=e.colors.length;a>r;++r){var l=e.colors[r];if("string"!=typeof l){var c=t.color.parse(s);null!=l.brightness&&(c=c.scale("rgb",l.brightness)),null!=l.opacity&&(c.a*=l.opacity),l=c.toString()}o.addColorStop(r/(a-1),l)}return o}var oe=[],re={colors:["#edc240","#afd8f8","#cb4b4b","#4da74d","#9440ed"],legend:{show:!0,noColumns:1,labelFormatter:null,labelBoxBorderColor:"#ccc",container:null,position:"ne",margin:5,backgroundColor:null,backgroundOpacity:.85},xaxis:{show:null,position:"bottom",mode:null,color:null,tickColor:null,transform:null,inverseTransform:null,min:null,max:null,autoscaleMargin:null,ticks:null,tickFormatter:null,labelWidth:null,labelHeight:null,reserveSpace:null,tickLength:null,alignTicksWithAxis:null,tickDecimals:null,tickSize:null,minTickSize:null,monthNames:null,timeformat:null,twelveHourClock:!1},yaxis:{autoscaleMargin:.02,position:"left"},xaxes:[],yaxes:[],series:{points:{show:!1,radius:3,lineWidth:2,fill:!0,fillColor:"#ffffff",symbol:"circle"},lines:{lineWidth:2,fill:!1,fillColor:null,steps:!1},bars:{show:!1,lineWidth:2,barWidth:1,fill:!0,fillColor:null,align:"left",horizontal:!1},shadowSize:3},grid:{show:!0,aboveData:!1,color:"#545454",backgroundColor:null,borderColor:null,tickColor:null,labelMargin:5,axisMargin:8,borderWidth:2,minBorderMargin:null,markings:null,markingsColor:"#f4f4f4",markingsLineWidth:2,clickable:!1,hoverable:!1,autoHighlight:!0,mouseActiveRadius:10},hooks:{}},ae=null,le=null,ce=null,he=null,ue=null,de=[],fe=[],pe={left:0,right:0,top:0,bottom:0},me=0,ge=0,ve=0,ye=0,be={processOptions:[],processRawData:[],processDatapoints:[],drawSeries:[],draw:[],bindEvents:[],drawOverlay:[],shutdown:[]},_e=this;_e.setData=h,_e.setupGrid=E,_e.draw=z,_e.getPlaceholder=function(){return e},_e.getCanvas=function(){return ae},_e.getPlotOffset=function(){return pe},_e.width=function(){return ve},_e.height=function(){return ye},_e.offset=function(){var t=ce.offset();return t.left+=pe.left,t.top+=pe.top,t},_e.getData=function(){return oe},_e.getAxes=function(){var e={};return t.each(de.concat(fe),function(t,i){i&&(e[i.direction+(1!=i.n?i.n:"")+"axis"]=i)}),e},_e.getXAxes=function(){return de},_e.getYAxes=function(){return fe},_e.c2p=p,_e.p2c=m,_e.getOptions=function(){return re},_e.highlight=Z,_e.unhighlight=te,_e.triggerRedrawOverlay=G,_e.pointOffset=function(t){return{left:parseInt(de[d(t,"x")-1].p2c(+t.x)+pe.left),top:parseInt(fe[d(t,"y")-1].p2c(+t.y)+pe.top)}},_e.shutdown=k,_e.resize=function(){_(),w(ae),w(le)},_e.hooks=be,l(_e),c(o),x(),h(s),E(),z(),C();var we=[],xe=null}function n(t,e){return e*Math.floor(t/e)}t.plot=function(i,n,s){var o=new e(t(i),n,s,t.plot.plugins);return o},t.plot.version="0.7",t.plot.plugins=[],t.plot.formatDate=function(t,e,i){var n=function(t){return t=""+t,1==t.length?"0"+t:t},s=[],o=!1,r=!1,a=t.getUTCHours(),l=12>a;null==i&&(i=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]),-1!=e.search(/%p|%P/)&&(a>12?a-=12:0==a&&(a=12));for(var c=0;c<e.length;++c){var h=e.charAt(c);if(o){switch(h){case"h":h=""+a;break;case"H":h=n(a);break;case"M":h=n(t.getUTCMinutes());break;case"S":h=n(t.getUTCSeconds());
break;case"d":h=""+t.getUTCDate();break;case"m":h=""+(t.getUTCMonth()+1);break;case"y":h=""+t.getUTCFullYear();break;case"b":h=""+i[t.getUTCMonth()];break;case"p":h=l?"am":"pm";break;case"P":h=l?"AM":"PM";break;case"0":h="",r=!0}h&&r&&(h=n(h),r=!1),s.push(h),r||(o=!1)}else"%"==h?o=!0:s.push(h)}return s.join("")}}(jQuery);