document.createElement("canvas").getContext||function(){function t(){return this.context_||(this.context_=new x(this))}function e(t,e){var i=L.call(arguments,2);return function(){return t.apply(e,i.concat(L.call(arguments)))}}function i(t){return String(t).replace(/&/g,"&amp;").replace(/"/g,"&quot;")}function n(t){if(t.namespaces.g_vml_||t.namespaces.add("g_vml_","urn:schemas-microsoft-com:vml","#default#VML"),t.namespaces.g_o_||t.namespaces.add("g_o_","urn:schemas-microsoft-com:office:office","#default#VML"),!t.styleSheets.ex_canvas_){var e=t.createStyleSheet();e.owningElement.id="ex_canvas_",e.cssText="canvas{display:inline-block;overflow:hidden;text-align:left;width:300px;height:150px}"}}function o(t){var e=t.srcElement;switch(t.propertyName){case"width":e.getContext().clearRect(),e.style.width=e.attributes.width.nodeValue+"px",e.firstChild.style.width=e.clientWidth+"px";break;case"height":e.getContext().clearRect(),e.style.height=e.attributes.height.nodeValue+"px",e.firstChild.style.height=e.clientHeight+"px"}}function r(t){var e=t.srcElement;e.firstChild&&(e.firstChild.style.width=e.clientWidth+"px",e.firstChild.style.height=e.clientHeight+"px")}function a(){return[[1,0,0],[0,1,0],[0,0,1]]}function c(t,e){for(var i=a(),n=0;3>n;n++)for(var s=0;3>s;s++){for(var o=0,r=0;3>r;r++)o+=t[n][r]*e[r][s];i[n][s]=o}return i}function u(t,e){e.fillStyle=t.fillStyle,e.lineCap=t.lineCap,e.lineJoin=t.lineJoin,e.lineWidth=t.lineWidth,e.miterLimit=t.miterLimit,e.shadowBlur=t.shadowBlur,e.shadowColor=t.shadowColor,e.shadowOffsetX=t.shadowOffsetX,e.shadowOffsetY=t.shadowOffsetY,e.strokeStyle=t.strokeStyle,e.globalAlpha=t.globalAlpha,e.font=t.font,e.textAlign=t.textAlign,e.textBaseline=t.textBaseline,e.arcScaleX_=t.arcScaleX_,e.arcScaleY_=t.arcScaleY_,e.lineScale_=t.lineScale_}function d(t){var e=t.indexOf("(",3),i=t.indexOf(")",e+1),n=t.substring(e+1,i).split(",");return 4==n.length&&"a"==t.substr(3,1)?alpha=Number(n[3]):n[3]=1,n}function p(t){return parseFloat(t)/100}function f(t,e,i){return Math.min(i,Math.max(e,t))}function m(t){var e,i,n;if(h=parseFloat(t[0])/360%360,0>h&&h++,s=f(p(t[1]),0,1),l=f(p(t[2]),0,1),0==s)e=i=n=l;else{var o=.5>l?l*(1+s):l+s-l*s,r=2*l-o;e=g(r,o,h+1/3),i=g(r,o,h),n=g(r,o,h-1/3)}return"#"+B[Math.floor(255*e)]+B[Math.floor(255*i)]+B[Math.floor(255*n)]}function g(t,e,i){return 0>i&&i++,i>1&&i--,1>6*i?t+6*(e-t)*i:1>2*i?e:2>3*i?t+6*(e-t)*(2/3-i):t}function v(t){var e,i=1;if(t=String(t),"#"==t.charAt(0))e=t;else if(/^rgb/.test(t)){for(var n,s=d(t),e="#",o=0;3>o;o++)n=-1!=s[o].indexOf("%")?Math.floor(255*p(s[o])):Number(s[o]),e+=B[f(n,0,255)];i=s[3]}else if(/^hsl/.test(t)){var s=d(t);e=m(s),i=s[3]}else e=V[t]||t;return{color:e,alpha:i}}function y(t){if(X[t])return X[t];var e=document.createElement("div"),i=e.style;try{i.font=t}catch(n){}return X[t]={style:i.fontStyle||Y.style,variant:i.fontVariant||Y.variant,weight:i.fontWeight||Y.weight,size:i.fontSize||Y.size,family:i.fontFamily||Y.family}}function b(t,e){var i={};for(var n in t)i[n]=t[n];var s=parseFloat(e.currentStyle.fontSize),o=parseFloat(t.size);return i.size="number"==typeof t.size?t.size:-1!=t.size.indexOf("px")?o:-1!=t.size.indexOf("em")?s*o:-1!=t.size.indexOf("%")?s/100*o:-1!=t.size.indexOf("pt")?o/.75:s,i.size*=.981,i}function _(t){return t.style+" "+t.variant+" "+t.weight+" "+t.size+"px "+t.family}function w(t){switch(t){case"butt":return"flat";case"round":return"round";case"square":default:return"square"}}function x(t){this.m_=a(),this.mStack_=[],this.aStack_=[],this.currentPath_=[],this.strokeStyle="#000",this.fillStyle="#000",this.lineWidth=1,this.lineJoin="miter",this.lineCap="butt",this.miterLimit=1*j,this.globalAlpha=1,this.font="10px sans-serif",this.textAlign="left",this.textBaseline="alphabetic",this.canvas=t;var e=t.ownerDocument.createElement("div");e.style.width=t.clientWidth+"px",e.style.height=t.clientHeight+"px",e.style.overflow="hidden",e.style.position="absolute",t.appendChild(e),this.element_=e,this.arcScaleX_=1,this.arcScaleY_=1,this.lineScale_=1}function C(t,e,i,n){t.currentPath_.push({type:"bezierCurveTo",cp1x:e.x,cp1y:e.y,cp2x:i.x,cp2y:i.y,x:n.x,y:n.y}),t.currentX_=n.x,t.currentY_=n.y}function k(t,e){var i=v(t.strokeStyle),n=i.color,s=i.alpha*t.globalAlpha,o=t.lineScale_*t.lineWidth;1>o&&(s*=o),e.push("<g_vml_:stroke",' opacity="',s,'"',' joinstyle="',t.lineJoin,'"',' miterlimit="',t.miterLimit,'"',' endcap="',w(t.lineCap),'"',' weight="',o,'px"',' color="',n,'" />')}function S(t,e,i,n){var s=t.fillStyle,o=t.arcScaleX_,r=t.arcScaleY_,a=n.x-i.x,l=n.y-i.y;if(s instanceof E){var h=0,c={x:0,y:0},u=0,d=1;if("gradient"==s.type_){var p=s.x0_/o,f=s.y0_/r,m=s.x1_/o,g=s.y1_/r,y=t.getCoords_(p,f),b=t.getCoords_(m,g),_=b.x-y.x,w=b.y-y.y;h=180*Math.atan2(_,w)/Math.PI,0>h&&(h+=360),1e-6>h&&(h=0)}else{var y=t.getCoords_(s.x0_,s.y0_);c={x:(y.x-i.x)/a,y:(y.y-i.y)/l},a/=o*j,l/=r*j;var x=N.max(a,l);u=2*s.r0_/x,d=2*s.r1_/x-u}var C=s.colors_;C.sort(function(t,e){return t.offset-e.offset});for(var k=C.length,S=C[0].color,T=C[k-1].color,D=C[0].alpha*t.globalAlpha,A=C[k-1].alpha*t.globalAlpha,P=[],I=0;k>I;I++){var F=C[I];P.push(F.offset*d+u+" "+F.color)}e.push('<g_vml_:fill type="',s.type_,'"',' method="none" focus="100%"',' color="',S,'"',' color2="',T,'"',' colors="',P.join(","),'"',' opacity="',A,'"',' g_o_:opacity2="',D,'"',' angle="',h,'"',' focusposition="',c.x,",",c.y,'" />')}else if(s instanceof M){if(a&&l){var z=-i.x,H=-i.y;e.push("<g_vml_:fill",' position="',z/a*o*o,",",H/l*r*r,'"',' type="tile"',' src="',s.src_,'" />')}}else{var $=v(t.fillStyle),O=$.color,W=$.alpha*t.globalAlpha;e.push('<g_vml_:fill color="',O,'" opacity="',W,'" />')}}function T(t){return isFinite(t[0][0])&&isFinite(t[0][1])&&isFinite(t[1][0])&&isFinite(t[1][1])&&isFinite(t[2][0])&&isFinite(t[2][1])}function D(t,e,i){if(T(e)&&(t.m_=e,i)){var n=e[0][0]*e[1][1]-e[0][1]*e[1][0];t.lineScale_=O($(n))}}function E(t){this.type_=t,this.x0_=0,this.y0_=0,this.r0_=0,this.x1_=0,this.y1_=0,this.r1_=0,this.colors_=[]}function M(t,e){switch(P(t),e){case"repeat":case null:case"":this.repetition_="repeat";break;case"repeat-x":case"repeat-y":case"no-repeat":this.repetition_=e;break;default:A("SYNTAX_ERR")}this.src_=t.src,this.width_=t.width,this.height_=t.height}function A(t){throw new I(t)}function P(t){t&&1==t.nodeType&&"IMG"==t.tagName||A("TYPE_MISMATCH_ERR"),"complete"!=t.readyState&&A("INVALID_STATE_ERR")}function I(t){this.code=this[t],this.message=t+": DOM Exception "+this.code}var N=Math,F=N.round,z=N.sin,H=N.cos,$=N.abs,O=N.sqrt,j=10,W=j/2,L=Array.prototype.slice;n(document);var R={init:function(t){if(/MSIE/.test(navigator.userAgent)&&!window.opera){var i=t||document;i.createElement("canvas"),i.attachEvent("onreadystatechange",e(this.init_,this,i))}},init_:function(t){for(var e=t.getElementsByTagName("canvas"),i=0;i<e.length;i++)this.initElement(e[i])},initElement:function(e){if(!e.getContext){e.getContext=t,n(e.ownerDocument),e.innerHTML="",e.attachEvent("onpropertychange",o),e.attachEvent("onresize",r);var i=e.attributes;i.width&&i.width.specified?e.style.width=i.width.nodeValue+"px":e.width=e.clientWidth,i.height&&i.height.specified?e.style.height=i.height.nodeValue+"px":e.height=e.clientHeight}return e}};R.init();for(var B=[],q=0;16>q;q++)for(var U=0;16>U;U++)B[16*q+U]=q.toString(16)+U.toString(16);var V={aliceblue:"#F0F8FF",antiquewhite:"#FAEBD7",aquamarine:"#7FFFD4",azure:"#F0FFFF",beige:"#F5F5DC",bisque:"#FFE4C4",black:"#000000",blanchedalmond:"#FFEBCD",blueviolet:"#8A2BE2",brown:"#A52A2A",burlywood:"#DEB887",cadetblue:"#5F9EA0",chartreuse:"#7FFF00",chocolate:"#D2691E",coral:"#FF7F50",cornflowerblue:"#6495ED",cornsilk:"#FFF8DC",crimson:"#DC143C",cyan:"#00FFFF",darkblue:"#00008B",darkcyan:"#008B8B",darkgoldenrod:"#B8860B",darkgray:"#A9A9A9",darkgreen:"#006400",darkgrey:"#A9A9A9",darkkhaki:"#BDB76B",darkmagenta:"#8B008B",darkolivegreen:"#556B2F",darkorange:"#FF8C00",darkorchid:"#9932CC",darkred:"#8B0000",darksalmon:"#E9967A",darkseagreen:"#8FBC8F",darkslateblue:"#483D8B",darkslategray:"#2F4F4F",darkslategrey:"#2F4F4F",darkturquoise:"#00CED1",darkviolet:"#9400D3",deeppink:"#FF1493",deepskyblue:"#00BFFF",dimgray:"#696969",dimgrey:"#696969",dodgerblue:"#1E90FF",firebrick:"#B22222",floralwhite:"#FFFAF0",forestgreen:"#228B22",gainsboro:"#DCDCDC",ghostwhite:"#F8F8FF",gold:"#FFD700",goldenrod:"#DAA520",grey:"#808080",greenyellow:"#ADFF2F",honeydew:"#F0FFF0",hotpink:"#FF69B4",indianred:"#CD5C5C",indigo:"#4B0082",ivory:"#FFFFF0",khaki:"#F0E68C",lavender:"#E6E6FA",lavenderblush:"#FFF0F5",lawngreen:"#7CFC00",lemonchiffon:"#FFFACD",lightblue:"#ADD8E6",lightcoral:"#F08080",lightcyan:"#E0FFFF",lightgoldenrodyellow:"#FAFAD2",lightgreen:"#90EE90",lightgrey:"#D3D3D3",lightpink:"#FFB6C1",lightsalmon:"#FFA07A",lightseagreen:"#20B2AA",lightskyblue:"#87CEFA",lightslategray:"#778899",lightslategrey:"#778899",lightsteelblue:"#B0C4DE",lightyellow:"#FFFFE0",limegreen:"#32CD32",linen:"#FAF0E6",magenta:"#FF00FF",mediumaquamarine:"#66CDAA",mediumblue:"#0000CD",mediumorchid:"#BA55D3",mediumpurple:"#9370DB",mediumseagreen:"#3CB371",mediumslateblue:"#7B68EE",mediumspringgreen:"#00FA9A",mediumturquoise:"#48D1CC",mediumvioletred:"#C71585",midnightblue:"#191970",mintcream:"#F5FFFA",mistyrose:"#FFE4E1",moccasin:"#FFE4B5",navajowhite:"#FFDEAD",oldlace:"#FDF5E6",olivedrab:"#6B8E23",orange:"#FFA500",orangered:"#FF4500",orchid:"#DA70D6",palegoldenrod:"#EEE8AA",palegreen:"#98FB98",paleturquoise:"#AFEEEE",palevioletred:"#DB7093",papayawhip:"#FFEFD5",peachpuff:"#FFDAB9",peru:"#CD853F",pink:"#FFC0CB",plum:"#DDA0DD",powderblue:"#B0E0E6",rosybrown:"#BC8F8F",royalblue:"#4169E1",saddlebrown:"#8B4513",salmon:"#FA8072",sandybrown:"#F4A460",seagreen:"#2E8B57",seashell:"#FFF5EE",sienna:"#A0522D",skyblue:"#87CEEB",slateblue:"#6A5ACD",slategray:"#708090",slategrey:"#708090",snow:"#FFFAFA",springgreen:"#00FF7F",steelblue:"#4682B4",tan:"#D2B48C",thistle:"#D8BFD8",tomato:"#FF6347",turquoise:"#40E0D0",violet:"#EE82EE",wheat:"#F5DEB3",whitesmoke:"#F5F5F5",yellowgreen:"#9ACD32"},Y={style:"normal",variant:"normal",weight:"normal",size:10,family:"sans-serif"},X={},Q=x.prototype;Q.clearRect=function(){this.textMeasureEl_&&(this.textMeasureEl_.removeNode(!0),this.textMeasureEl_=null),this.element_.innerHTML=""},Q.beginPath=function(){this.currentPath_=[]},Q.moveTo=function(t,e){var i=this.getCoords_(t,e);this.currentPath_.push({type:"moveTo",x:i.x,y:i.y}),this.currentX_=i.x,this.currentY_=i.y},Q.lineTo=function(t,e){var i=this.getCoords_(t,e);this.currentPath_.push({type:"lineTo",x:i.x,y:i.y}),this.currentX_=i.x,this.currentY_=i.y},Q.bezierCurveTo=function(t,e,i,n,s,o){var r=this.getCoords_(s,o),a=this.getCoords_(t,e),l=this.getCoords_(i,n);C(this,a,l,r)},Q.quadraticCurveTo=function(t,e,i,n){var s=this.getCoords_(t,e),o=this.getCoords_(i,n),r={x:this.currentX_+2/3*(s.x-this.currentX_),y:this.currentY_+2/3*(s.y-this.currentY_)},a={x:r.x+(o.x-this.currentX_)/3,y:r.y+(o.y-this.currentY_)/3};C(this,r,a,o)},Q.arc=function(t,e,i,n,s,o){i*=j;var r=o?"at":"wa",a=t+H(n)*i-W,l=e+z(n)*i-W,h=t+H(s)*i-W,c=e+z(s)*i-W;a!=h||o||(a+=.125);var u=this.getCoords_(t,e),d=this.getCoords_(a,l),p=this.getCoords_(h,c);this.currentPath_.push({type:r,x:u.x,y:u.y,radius:i,xStart:d.x,yStart:d.y,xEnd:p.x,yEnd:p.y})},Q.rect=function(t,e,i,n){this.moveTo(t,e),this.lineTo(t+i,e),this.lineTo(t+i,e+n),this.lineTo(t,e+n),this.closePath()},Q.strokeRect=function(t,e,i,n){var s=this.currentPath_;this.beginPath(),this.moveTo(t,e),this.lineTo(t+i,e),this.lineTo(t+i,e+n),this.lineTo(t,e+n),this.closePath(),this.stroke(),this.currentPath_=s},Q.fillRect=function(t,e,i,n){var s=this.currentPath_;this.beginPath(),this.moveTo(t,e),this.lineTo(t+i,e),this.lineTo(t+i,e+n),this.lineTo(t,e+n),this.closePath(),this.fill(),this.currentPath_=s},Q.createLinearGradient=function(t,e,i,n){var s=new E("gradient");return s.x0_=t,s.y0_=e,s.x1_=i,s.y1_=n,s},Q.createRadialGradient=function(t,e,i,n,s,o){var r=new E("gradientradial");return r.x0_=t,r.y0_=e,r.r0_=i,r.x1_=n,r.y1_=s,r.r1_=o,r},Q.drawImage=function(t){var e,i,n,s,o,r,a,l,h=t.runtimeStyle.width,c=t.runtimeStyle.height;t.runtimeStyle.width="auto",t.runtimeStyle.height="auto";var u=t.width,d=t.height;if(t.runtimeStyle.width=h,t.runtimeStyle.height=c,3==arguments.length)e=arguments[1],i=arguments[2],o=r=0,a=n=u,l=s=d;else if(5==arguments.length)e=arguments[1],i=arguments[2],n=arguments[3],s=arguments[4],o=r=0,a=u,l=d;else{if(9!=arguments.length)throw Error("Invalid number of arguments");o=arguments[1],r=arguments[2],a=arguments[3],l=arguments[4],e=arguments[5],i=arguments[6],n=arguments[7],s=arguments[8]}var p=this.getCoords_(e,i),f=[],m=10,g=10;if(f.push(" <g_vml_:group",' coordsize="',j*m,",",j*g,'"',' coordorigin="0,0"',' style="width:',m,"px;height:",g,"px;position:absolute;"),1!=this.m_[0][0]||this.m_[0][1]||1!=this.m_[1][1]||this.m_[1][0]){var v=[];v.push("M11=",this.m_[0][0],",","M12=",this.m_[1][0],",","M21=",this.m_[0][1],",","M22=",this.m_[1][1],",","Dx=",F(p.x/j),",","Dy=",F(p.y/j),"");var y=p,b=this.getCoords_(e+n,i),_=this.getCoords_(e,i+s),w=this.getCoords_(e+n,i+s);y.x=N.max(y.x,b.x,_.x,w.x),y.y=N.max(y.y,b.y,_.y,w.y),f.push("padding:0 ",F(y.x/j),"px ",F(y.y/j),"px 0;filter:progid:DXImageTransform.Microsoft.Matrix(",v.join(""),", sizingmethod='clip');")}else f.push("top:",F(p.y/j),"px;left:",F(p.x/j),"px;");f.push(' ">','<g_vml_:image src="',t.src,'"',' style="width:',j*n,"px;"," height:",j*s,'px"',' cropleft="',o/u,'"',' croptop="',r/d,'"',' cropright="',(u-o-a)/u,'"',' cropbottom="',(d-r-l)/d,'"'," />","</g_vml_:group>"),this.element_.insertAdjacentHTML("BeforeEnd",f.join(""))},Q.stroke=function(t){for(var e=10,i=10,n=5e3,s={x:null,y:null},o={x:null,y:null},r=0;r<this.currentPath_.length;r+=n){var a=[];a.push("<g_vml_:shape",' filled="',!!t,'"',' style="position:absolute;width:',e,"px;height:",i,'px;"',' coordorigin="0,0"',' coordsize="',j*e,",",j*i,'"',' stroked="',!t,'"',' path="');for(var l=r;l<Math.min(r+n,this.currentPath_.length);l++){0==l%n&&l>0&&a.push(" m ",F(this.currentPath_[l-1].x),",",F(this.currentPath_[l-1].y));var h,c=this.currentPath_[l];switch(c.type){case"moveTo":h=c,a.push(" m ",F(c.x),",",F(c.y));break;case"lineTo":a.push(" l ",F(c.x),",",F(c.y));break;case"close":a.push(" x "),c=null;break;case"bezierCurveTo":a.push(" c ",F(c.cp1x),",",F(c.cp1y),",",F(c.cp2x),",",F(c.cp2y),",",F(c.x),",",F(c.y));break;case"at":case"wa":a.push(" ",c.type," ",F(c.x-this.arcScaleX_*c.radius),",",F(c.y-this.arcScaleY_*c.radius)," ",F(c.x+this.arcScaleX_*c.radius),",",F(c.y+this.arcScaleY_*c.radius)," ",F(c.xStart),",",F(c.yStart)," ",F(c.xEnd),",",F(c.yEnd))}c&&((null==s.x||c.x<s.x)&&(s.x=c.x),(null==o.x||c.x>o.x)&&(o.x=c.x),(null==s.y||c.y<s.y)&&(s.y=c.y),(null==o.y||c.y>o.y)&&(o.y=c.y))}a.push(' ">'),t?S(this,a,s,o):k(this,a),a.push("</g_vml_:shape>"),this.element_.insertAdjacentHTML("beforeEnd",a.join(""))}},Q.fill=function(){this.stroke(!0)},Q.closePath=function(){this.currentPath_.push({type:"close"})},Q.getCoords_=function(t,e){var i=this.m_;return{x:j*(t*i[0][0]+e*i[1][0]+i[2][0])-W,y:j*(t*i[0][1]+e*i[1][1]+i[2][1])-W}},Q.save=function(){var t={};u(this,t),this.aStack_.push(t),this.mStack_.push(this.m_),this.m_=c(a(),this.m_)},Q.restore=function(){this.aStack_.length&&(u(this.aStack_.pop(),this),this.m_=this.mStack_.pop())},Q.translate=function(t,e){var i=[[1,0,0],[0,1,0],[t,e,1]];D(this,c(i,this.m_),!1)},Q.rotate=function(t){var e=H(t),i=z(t),n=[[e,i,0],[-i,e,0],[0,0,1]];D(this,c(n,this.m_),!1)},Q.scale=function(t,e){this.arcScaleX_*=t,this.arcScaleY_*=e;var i=[[t,0,0],[0,e,0],[0,0,1]];D(this,c(i,this.m_),!0)},Q.transform=function(t,e,i,n,s,o){var r=[[t,e,0],[i,n,0],[s,o,1]];D(this,c(r,this.m_),!0)},Q.setTransform=function(t,e,i,n,s,o){var r=[[t,e,0],[i,n,0],[s,o,1]];D(this,r,!0)},Q.drawText_=function(t,e,n,s,o){var r=this.m_,a=1e3,l=0,h=a,c={x:0,y:0},u=[],d=b(y(this.font),this.element_),p=_(d),f=this.element_.currentStyle,m=this.textAlign.toLowerCase();switch(m){case"left":case"center":case"right":break;case"end":m="ltr"==f.direction?"right":"left";break;case"start":m="rtl"==f.direction?"right":"left";break;default:m="left"}switch(this.textBaseline){case"hanging":case"top":c.y=d.size/1.75;break;case"middle":break;default:case null:case"alphabetic":case"ideographic":case"bottom":c.y=-d.size/2.25}switch(m){case"right":l=a,h=.05;break;case"center":l=h=a/2}var g=this.getCoords_(e+c.x,n+c.y);u.push('<g_vml_:line from="',-l,' 0" to="',h,' 0.05" ',' coordsize="100 100" coordorigin="0 0"',' filled="',!o,'" stroked="',!!o,'" style="position:absolute;width:1px;height:1px;">'),o?k(this,u):S(this,u,{x:-l,y:0},{x:h,y:d.size});var v=r[0][0].toFixed(3)+","+r[1][0].toFixed(3)+","+r[0][1].toFixed(3)+","+r[1][1].toFixed(3)+",0,0",w=F(g.x/j)+","+F(g.y/j);u.push('<g_vml_:skew on="t" matrix="',v,'" ',' offset="',w,'" origin="',l,' 0" />','<g_vml_:path textpathok="true" />','<g_vml_:textpath on="true" string="',i(t),'" style="v-text-align:',m,";font:",i(p),'" /></g_vml_:line>'),this.element_.insertAdjacentHTML("beforeEnd",u.join(""))},Q.fillText=function(t,e,i,n){this.drawText_(t,e,i,n,!1)},Q.strokeText=function(t,e,i,n){this.drawText_(t,e,i,n,!0)},Q.measureText=function(t){if(!this.textMeasureEl_){var e='<span style="position:absolute;top:-20000px;left:0;padding:0;margin:0;border:none;white-space:pre;"></span>';this.element_.insertAdjacentHTML("beforeEnd",e),this.textMeasureEl_=this.element_.lastChild}var i=this.element_.ownerDocument;return this.textMeasureEl_.innerHTML="",this.textMeasureEl_.style.font=this.font,this.textMeasureEl_.appendChild(i.createTextNode(t)),{width:this.textMeasureEl_.offsetWidth}},Q.clip=function(){},Q.arcTo=function(){},Q.createPattern=function(t,e){return new M(t,e)},E.prototype.addColorStop=function(t,e){e=v(e),this.colors_.push({offset:t,color:e.color,alpha:e.alpha})};var K=I.prototype=new Error;K.INDEX_SIZE_ERR=1,K.DOMSTRING_SIZE_ERR=2,K.HIERARCHY_REQUEST_ERR=3,K.WRONG_DOCUMENT_ERR=4,K.INVALID_CHARACTER_ERR=5,K.NO_DATA_ALLOWED_ERR=6,K.NO_MODIFICATION_ALLOWED_ERR=7,K.NOT_FOUND_ERR=8,K.NOT_SUPPORTED_ERR=9,K.INUSE_ATTRIBUTE_ERR=10,K.INVALID_STATE_ERR=11,K.SYNTAX_ERR=12,K.INVALID_MODIFICATION_ERR=13,K.NAMESPACE_ERR=14,K.INVALID_ACCESS_ERR=15,K.VALIDATION_ERR=16,K.TYPE_MISMATCH_ERR=17,G_vmlCanvasManager=R,CanvasRenderingContext2D=x,CanvasGradient=E,CanvasPattern=M,DOMException=I}();