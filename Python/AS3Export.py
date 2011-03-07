#!BPY 
""" 
Name: 'ActionScript 3.0 Class (.as) ...'
Blender: 240
Group: 'Export'
Tooltip: 'Export geometry to ActionScript 3.0 Class (.as)'
""" 

# --------------------------------------------------------------------------
# ***** BEGIN GPL LICENSE BLOCK *****
#
# Copyright (C) 2007-2008 Dennis Ippel
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# ***** END GPL LICENCE BLOCK *****
# --------------------------------------------------------------------------

__author__ = "Dennis Ippel"
__url__ = ("http://www.rozengain.com")
__version__ = "0.4"

__bpydoc__ = """

For more information please go to:
http://www.rozengain.com
"""

#triangulate: go into edit mode, select all faces and press ctrl+t
 
from Blender import Scene, Mesh, Window, Get, sys, Image, Draw
import BPyMessages 
import bpy 
import math
from math import *
from Blender.BGL import *

EVENT_NOEVENT = 1
EVENT_DRAW = 2
EVENT_EXIT = 3
EVENT_EXPORT = 4
EVENT_BROWSEFILE = 5

as_package_name = Draw.Create("")
as_output_string = ""
as_filename = ""
fileButton = Draw.Create("")
engine_menu = Draw.Create(1)
export_all = None

def export_papervision(me, class_name): 
	as_output_string = 		"package "+as_package_name.val+" {\n"
	as_output_string +=		"\timport org.papervision3d.core.*;\n"
	as_output_string += 	"\timport org.papervision3d.materials.*;\n"
	as_output_string +=		"\timport org.papervision3d.core.proto.*;\n"
	as_output_string +=		"\timport org.papervision3d.core.geom.*;\n\n"
	as_output_string +=		"\tpublic class "+class_name+" extends Mesh3D {\n"
	as_output_string +=		"\t\tprivate var ve:Array;\n"
	as_output_string +=		"\t\tprivate var fa:Array;\n\n"
	as_output_string +=		"\t\tpublic function "+class_name+"(material : MaterialObject3D, initObject:Object=null ) {\n"
	as_output_string +=		"\t\t\tsuper( material, new Array(), new Array(), null, initObject );\n"
	as_output_string +=		"\t\t\tve = this.geometry.vertices;\n"
	as_output_string +=		"\t\t\tfa = this.geometry.faces;\n"
	 
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.z, v.co.y)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			as_output_string += "\t\t\tf(%i,%i,%i,null,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z )
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotationX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotationY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotationZ = %f;\n" % ob_rotY
	
	as_output_string += "\n\t\t\tthis.scaleX = %f;\n" % ob_scaleX
	as_output_string += "\t\t\tthis.scaleY = %f;\n" % ob_scaleZ
	as_output_string += "\t\t\tthis.scaleZ = %f;\n" % ob_scaleY

	as_output_string += "\n\t\t\tthis.geometry.ready = true;\n"
	as_output_string += "\t\t}\n"
	
	as_output_string += "\t\tpublic function v(x:Number, y:Number, z:Number):void {\n"
	as_output_string += "\t\t\tve.push(new Vertex3D(x, y, z));\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number, imageName:String, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {\n"
	as_output_string += "\t\t\tvar face:Face3D = new Face3D( [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], imageName, [ {u: uv00, v: uv01}, {u: uv10, v: uv11}, {u: uv20, v: uv21} ] );\n"
	as_output_string += "\t\t\tface.faceNormal = new Number3D(normalx,normaly,normalz);\n" % ()
	as_output_string += "\t\t\tfa.push(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f2(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number):void {\n"
	as_output_string += "\t\t\tvar face:Face3D = new Face3D([ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]]);\n"
	as_output_string += "\t\t\tfa.push(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t}\n}"
	
	save_file(as_output_string, class_name)

def export_papervision2(me, class_name): 
	as_output_string = 		"package "+as_package_name.val+" {\n"
	
	as_output_string +=		"\timport org.papervision3d.core.math.NumberUV;\n"
	as_output_string +=		"\timport org.papervision3d.core.math.Number3D;\n"
	as_output_string +=		"\timport org.papervision3d.core.geom.renderables.Triangle3D;\n"
	as_output_string +=		"\timport org.papervision3d.core.geom.renderables.Vertex3D;\n"
	as_output_string +=		"\timport org.papervision3d.core.geom.TriangleMesh3D;\n"
	as_output_string +=		"\timport org.papervision3d.core.proto.MaterialObject3D;\n\n"	
	as_output_string +=		"\tpublic class "+class_name+" extends TriangleMesh3D {\n"
	as_output_string +=		"\t\tprivate var ve:Array;\n"
	as_output_string +=		"\t\tprivate var fa:Array;\n\n"
	as_output_string +=		"\t\tpublic function "+class_name+"(material : MaterialObject3D ) {\n"
	as_output_string +=		"\t\t\tsuper( material, new Array(), new Array() );\n"
	as_output_string +=		"\t\t\tve = this.geometry.vertices;\n"
	as_output_string +=		"\t\t\tfa = this.geometry.faces;\n"
	 
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.z, v.co.y)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			as_output_string += "\t\t\tf(%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z )
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotationX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotationY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotationZ = %f;\n" % ob_rotY
	
	as_output_string += "\n\t\t\tthis.scaleX = %f;\n" % ob_scaleX
	as_output_string += "\t\t\tthis.scaleY = %f;\n" % ob_scaleZ
	as_output_string += "\t\t\tthis.scaleZ = %f;\n" % ob_scaleY

	as_output_string += "\n\t\t\tthis.geometry.ready = true;\n"
	as_output_string += "\t\t}\n"
	
	as_output_string += "\t\tpublic function v(x:Number, y:Number, z:Number):void {\n"
	as_output_string += "\t\t\tve.push(new Vertex3D(x, y, z));\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {\n"
	as_output_string += "\t\t\tvar face : Triangle3D = new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], null, [ new NumberUV(uv00, uv01), new NumberUV(uv10, uv11), new NumberUV(uv20, uv21) ] );\n"
	as_output_string += "\t\t\tface.faceNormal = new Number3D(normalx,normaly,normalz);\n" % ()
	as_output_string += "\t\t\tfa.push(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f2(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number):void {\n"
	as_output_string += "\t\t\tvar face:Triangle3D = new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], null, []);\n"
	as_output_string += "\t\t\tfa.push(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t}\n}"
	
	save_file(as_output_string, class_name)
	
def export_away3d(me, class_name): 
	as_output_string = 		"package "+as_package_name.val+" {\n"
	as_output_string +=		"\timport away3d.core.*;\n"
	as_output_string +=		"\timport away3d.core.mesh.*;\n"
	as_output_string +=		"\timport away3d.core.material.*;\n"
	as_output_string +=		"\timport away3d.core.utils.*;\n\n"

	as_output_string +=		"\tpublic class "+class_name+" extends Mesh {\n"
	as_output_string +=		"\t\tprivate var ve:Array;\n"
	as_output_string +=		"\t\tprivate var fa:Array;\n\n"
	as_output_string +=		"\t\tpublic function "+class_name+"(init:Object = null) {\n"
	as_output_string +=		"\t\t\tsuper( init );\n"
	as_output_string +=		"\t\t\tinit = Init.parse(init);\n"
	as_output_string +=		"\t\t\tve = [];\n"
	 
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.z, v.co.y)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			as_output_string += "\t\t\tf(%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z )
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotationX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotationY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotationZ = %f;\n" % ob_rotY
	
	as_output_string += "\n\t\t\tthis.scaleXYZ(%f, %f, %f);\n" % (ob_scaleX, ob_scaleZ, ob_scaleY)

	as_output_string += "\t\t}\n"
	
	as_output_string += "\t\tpublic function v(x:Number, y:Number, z:Number):void {\n"
	as_output_string += "\t\t\tve.push(new Vertex(x, y, z));\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {\n"
	as_output_string += "\t\t\tvar face:Face = new Face( ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3], null, new UV(uv00, uv01), new UV(uv10, uv11), new UV(uv20, uv21) );\n"
	as_output_string += "\t\t\taddFace(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f2(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int):void {\n"
	as_output_string += "\t\t\taddFace( new Face(ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]) );\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t}\n}"
	
	save_file(as_output_string, class_name)

def export_away3d_210(me, class_name): 
	as_output_string = 		"package "+as_package_name.val+" {\n"
	as_output_string +=		"\timport away3d.core.base.Face;\n"
	as_output_string +=		"\timport away3d.core.base.Mesh;\n"
	as_output_string +=		"\timport away3d.core.base.UV;\n"
	as_output_string +=		"\timport away3d.core.base.Vertex;\n"
	as_output_string +=		"\timport away3d.core.utils.Init;\n\n"

	as_output_string +=		"\tpublic class "+class_name+" extends Mesh {\n"
	as_output_string +=		"\t\tprivate var ve:Array;\n"
	as_output_string +=		"\t\tprivate var fa:Array;\n\n"
	as_output_string +=		"\t\tpublic function "+class_name+"(init:Object = null) {\n"
	as_output_string +=		"\t\t\tsuper( init );\n"
	as_output_string +=		"\t\t\tinit = Init.parse(init);\n"
	as_output_string +=		"\t\t\tve = [];\n"
	 
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.z, v.co.y)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			as_output_string += "\t\t\tf(%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z )
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotationX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotationY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotationZ = %f;\n" % ob_rotY
	
	as_output_string += "\n\t\t\tthis.scaleXYZ(%f, %f, %f);\n" % (ob_scaleX, ob_scaleZ, ob_scaleY)

	as_output_string += "\t\t}\n"
	
	as_output_string += "\t\tpublic function v(x:Number, y:Number, z:Number):void {\n"
	as_output_string += "\t\t\tve.push(new Vertex(x, y, z));\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {\n"
	as_output_string += "\t\t\tvar face:Face = new Face( ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3], null, new UV(uv00, uv01), new UV(uv10, uv11), new UV(uv20, uv21) );\n"
	as_output_string += "\t\t\taddFace(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f2(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int):void {\n"
	as_output_string += "\t\t\taddFace( new Face(ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]) );\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t}\n}"
	
	save_file(as_output_string, class_name)


##########################################################################################
# Thanks to Andrea Boschini (Panurge Web Design, http://www.panurge.it)
# for this addition
##########################################################################################
 	
def export_away3d_220(me, class_name): 
	as_output_string = 		"package "+as_package_name.val+" {\n"
	as_output_string +=		"\timport away3d.core.base.Face;\n"
	as_output_string +=		"\timport away3d.core.base.Mesh;\n"
	as_output_string +=		"\timport away3d.core.base.UV;\n"
	as_output_string +=		"\timport away3d.core.base.Vertex;\n"
	as_output_string +=		"\timport away3d.core.utils.Init;\n\n"

	as_output_string +=		"\tpublic class "+class_name+" extends Mesh {\n"
	as_output_string +=		"\t\tprivate var ve:Array;\n"
	as_output_string +=		"\t\tprivate var fa:Array;\n\n"
	as_output_string +=		"\t\tpublic function "+class_name+"(init:Object = null) {\n"
	as_output_string +=		"\t\t\tsuper( init );\n"
	as_output_string +=		"\t\t\tinit = Init.parse(init);\n"
	as_output_string +=		"\t\t\tve = [];\n"
	 
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.z, v.co.y)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			as_output_string += "\t\t\tf(%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z )
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotationX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotationY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotationZ = %f;\n" % ob_rotY

	as_output_string += "\n\t\t\tthis.scaleX = %f;\n" % ob_scaleX
	as_output_string += "\n\t\t\tthis.scaleY = %f;\n" % ob_scaleZ
	as_output_string += "\n\t\t\tthis.scaleZ = %f;\n" % ob_scaleY

	as_output_string += "\t\t}\n"
	
	as_output_string += "\t\tpublic function v(x:Number, y:Number, z:Number):void {\n"
	as_output_string += "\t\t\tve.push(new Vertex(x, y, z));\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void {\n"
	as_output_string += "\t\t\tvar face:Face = new Face( ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3], null, new UV(uv00, uv01), new UV(uv10, uv11), new UV(uv20, uv21) );\n"
	as_output_string += "\t\t\taddFace(face);\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t\tpublic function f2(vertexIndex1:int, vertexIndex2:int, vertexIndex3:int):void {\n"
	as_output_string += "\t\t\taddFace( new Face(ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]) );\n"
	as_output_string += "\t\t}\n\n"
	
	as_output_string += "\t}\n}"
	
	save_file(as_output_string, class_name)
	
##########################################################################################
# Thanks to Makc (http://makc3d.wordpress.com/)
# for the quads addition
##########################################################################################

def export_sandy(me, class_name):
	as_output_string = 		"package "+as_package_name.val+" {\n"
	as_output_string +=		"\timport sandy.primitive.Primitive3D;\n"
	as_output_string +=		"\timport sandy.core.scenegraph.Geometry3D;\n"
	as_output_string +=		"\timport sandy.core.scenegraph.Shape3D;\n\n"

	as_output_string +=		"\tpublic class "+class_name+" extends Shape3D implements Primitive3D {\n"
	as_output_string +=		"\t\tprivate var l:Geometry3D;\n\n"

	as_output_string +=		"\t\tprivate function f(v1:Number,v2:Number,v3:Number,uv00:Number,uv01:Number,uv10:Number,uv11:Number,uv20:Number,uv21:Number,normX:Number,normY:Number,normZ:Number):void {\n"
	as_output_string +=		"\t\t\tvar uv1:Number = l.getNextUVCoordID();\n"
	as_output_string +=		"\t\t\tvar uv2:Number = uv1 + 1;\n"
	as_output_string +=		"\t\t\tvar uv3:Number = uv2 + 1;\n\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv1,uv00,1-uv01);\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv2,uv10,1-uv11);\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv3,uv20,1-uv21);\n\n"
	as_output_string +=		"\t\t\tl.setFaceVertexIds(l.getNextFaceID(), v1,v2,v3);\n"
	as_output_string +=		"\t\t\tl.setFaceUVCoordsIds(l.getNextFaceUVCoordID(), uv1,uv2,uv3);\n"
	as_output_string +=		"\t\t\tl.setFaceNormal(l.getNextFaceNormalID(), normX,normZ,normY);\n"
	as_output_string +=		"\t\t}\n\n"
	
	as_output_string +=		"\t\tprivate function f4(v1:Number,v2:Number,v3:Number,v4:Number,uv00:Number,uv01:Number,uv10:Number,uv11:Number,uv20:Number,uv21:Number,uv30:Number,uv31:Number,normX:Number,normY:Number,normZ:Number):void {\n"
	as_output_string +=		"\t\t\tvar uv1:Number = l.getNextUVCoordID();\n"
	as_output_string +=		"\t\t\tvar uv2:Number = uv1 + 1;\n"
	as_output_string +=		"\t\t\tvar uv3:Number = uv2 + 1;\n"
	as_output_string +=		"\t\t\tvar uv4:Number = uv3 + 1;\n\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv1,uv00,1-uv01);\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv2,uv10,1-uv11);\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv3,uv20,1-uv21);\n"
	as_output_string +=		"\t\t\tl.setUVCoords(uv4,uv30,1-uv31);\n\n"
	as_output_string +=		"\t\t\tl.setFaceVertexIds(l.getNextFaceID(),v1,v2,v3,v4);\n"
	as_output_string +=		"\t\t\tl.setFaceUVCoordsIds(l.getNextFaceUVCoordID(),uv1,uv2,uv3,uv4);\n"
	as_output_string +=		"\t\t\tl.setFaceNormal(l.getNextFaceNormalID(),normX,normZ,normY);\n"
	as_output_string +=		"\t\t}\n\n"
	
	as_output_string +=		"\t\tprivate function f2(v1:Number,v2:Number,v3:Number):void {\n"
	as_output_string +=		"\t\t\tl.setFaceVertexIds(l.getNextFaceID(), v1,v2,v3);\n"
	as_output_string +=		"\t\t}\n\n"
	
	as_output_string +=		"\t\tprivate function v(vx:Number,vy:Number,vz:Number):void {\n"
	as_output_string +=		"\t\t\tl.setVertex(l.getNextVertexID(),vx,vz,vy);\n"
	as_output_string +=		"\t\t}\n\n"

	as_output_string +=		"\t\tpublic function "+class_name+"( p_Name:String=null ) {\n"
	as_output_string +=		"\t\t\tsuper( p_Name );\n"
	as_output_string +=		"\t\t\tgeometry = generate();\n"
	as_output_string +=		"\t\t}\n\n"

	as_output_string +=		"\t\tpublic function generate(... arguments):Geometry3D {\n"
	as_output_string +=		"\t\t\tl = new Geometry3D();\n"
	
	#generate geometry
	for v in me.verts: 
		#global as_output_string
		as_output_string += "\t\t\tv(%f,%f,%f);\n" % (v.co.x, v.co.y, v.co.z)
	
	as_output_string += "\n"
	
	for f in me.faces:
		if me.faceUV:
			if len(f.uv) < 4:
				as_output_string += "\t\t\tf(%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index,f.verts[1].index, f.verts[2].index, f.uv[0][0], f.uv[0][1],f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.no.x, f.no.y, f.no.z)
			else:
				as_output_string += "\t\t\tf4(%i,%i,%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index, f.verts[3].index, f.uv[0][0], f.uv[0][1], f.uv[1][0], f.uv[1][1], f.uv[2][0], f.uv[2][1], f.uv[3][0], f.uv[3][1], f.no.x, f.no.y, f.no.z)
		if not me.faceUV:
			as_output_string += "\t\t\tf2(%i,%i,%i);\n" % (f.verts[0].index, f.verts[1].index, f.verts[2].index)
	
	as_output_string += "\n\t\t\tthis.x = %f;\n" % ob_locX
	as_output_string += "\t\t\tthis.y = %f;\n" % ob_locZ
	as_output_string += "\t\t\tthis.z = %f;\n" % ob_locY
	
	as_output_string += "\n\t\t\tthis.rotateX = %f;\n" % ob_rotX
	as_output_string += "\t\t\tthis.rotateY = %f;\n" % ob_rotZ
	as_output_string += "\t\t\tthis.rotateZ = %f;\n" % ob_rotY
	
	as_output_string += "\n\t\t\tthis.scaleX = %f;\n" % ob_scaleX
	as_output_string += "\t\t\tthis.scaleY = %f;\n" % ob_scaleZ
	as_output_string += "\t\t\tthis.scaleZ = %f;\n" % ob_scaleY

	as_output_string +=		"\t\t\treturn (l);\n"
	as_output_string +=		"\t\t}\n"
	as_output_string +=		"\t}\n"
	as_output_string +=		"}"
	
	save_file(as_output_string, class_name)

def save_file(file_contents, class_name):
	try:
		f = open(fileButton.val+""+class_name+".as", 'w')
		f.write(file_contents)
		f.close()
		print "Export Successful: "+class_name+".as"
	except:
		Draw.PupMenu("Export failed | Check the console for more info")
		raise # throw the exception

	Draw.Exit()
	
def main(): 
	# Gets the current scene, there can be many scenes in 1 blend file. 
	sce = bpy.data.scenes.active 
	 
	# Get the active object, there can only ever be 1 
	# and the active object is always the editmode object. 
	#ob_act = sce.objects.active 
	ob_act = sce.objects.active
	 
	if not ob_act or ob_act.type != 'Mesh': 
		BPyMessages.Error_NoMeshActive() 
		return  

	# Saves the editmode state and go's out of  
	# editmode if its enabled, we cant make 
	# changes to the mesh data while in editmode. 
	is_editmode = Window.EditMode() 
	if is_editmode: Window.EditMode(0) 
	 
	Window.WaitCursor(1) 
	me = ob_act.getData(mesh=1) # old NMesh api is default 
	t = sys.time() 
	
	# Restore editmode if it was enabled 
	if is_editmode: Window.EditMode(1) 
	 
	print 'ActionScript 3.0 Exporter Script finished in %.2f seconds' % (sys.time()-t) 
	Window.WaitCursor(0) 

# This lets you can import the script without running it 
if __name__ == '__main__': 
	main() 

def event(evt, val):
	if (evt == Draw.QKEY and not val):
		Draw.Exit()

def bevent(evt):
	global EVENT_NOEVENT,EVENT_DRAW,EVENT_EXIT
	
	if (evt == EVENT_EXIT):
		Draw.Exit()
	elif (evt== EVENT_DRAW):
		Draw.Redraw()
	elif (evt== EVENT_EXPORT):
		sce = bpy.data.scenes.active 
		
		if(export_all == 1):
			print "oh ja"
			# get a list of mesh objects
			obs = [ob for ob in sce.objects if ob.type == 'Mesh']
		   
			# export all object names
			for ob in obs:
				me = Mesh.New()
				me.getFromObject(ob,0)
				print(me.name)
				export_to_as(ob)
			Draw.PupMenu("Export Successful")
		else:
			export_to_as(sce.objects.active)
			Draw.PupMenu("Export Successful")
	elif (evt== EVENT_BROWSEFILE):
		Window.FileSelector(FileSelected,"Export .as", expFileName)
		Draw.Redraw(1)

def export_to_as(ob):
	me = Mesh.New()
	me.getFromObject(ob,0)
	
	class_name = ob.name.replace(".", "")
	
	#get transformations
	global ob_locX, ob_locY, ob_locZ, ob_mtrx, ob_rotX, ob_rotY, ob_rotZ, ob_scaleX, ob_scaleY, ob_scaleZ
	ob_locX = ob.LocX
	ob_locY = ob.LocY
	ob_locZ = ob.LocZ
	ob_mtrx = ob.matrix.rotationPart()
	ob_rotX = ob.RotX * (180 / pi)
	ob_rotY = ob.RotY * (180 / pi)
	ob_rotZ = ob.RotZ * (180 / pi)
	ob_scaleX = ob.SizeX
	ob_scaleY = ob.SizeY
	ob_scaleZ = ob.SizeZ	
	
	if (engine_menu.val == 2):
		export_papervision(me, class_name) 
	elif (engine_menu.val == 3 ):
		export_papervision2(me, class_name)
	elif (engine_menu.val == 4 ):
		export_sandy(me, class_name)
	elif (engine_menu.val == 1 ):
		export_away3d(me, class_name)
	elif (engine_menu.val == 5 ):
		export_away3d_210(me, class_name)	
	elif (engine_menu.val == 6 ):
		export_away3d_220(me, class_name)		
		
def FileSelected(fileName):
	global fileButton
	
	if fileName != '':
		# check if file exists
		#if sys.exists(fileName) != 1:
		#	cutils.Debug.Debug('File(%s) does not exist' % (fileName),'ERROR')
		#	return False
		
		fileButton.val = fileName
	else:
		cutils.Debug.Debug('ERROR: filename is empty','ERROR')

######################################################
# GUI drawing
######################################################
def draw():
	global as_package_name
	global fileButton, expFileName
	global engine_menu, engine_name
	global EVENT_NOEVENT,EVENT_DRAW,EVENT_EXIT,EVENT_EXPORT
	global export_all
	expFileName = ""
	########## Titles
	glClear(GL_COLOR_BUFFER_BIT)
	glRasterPos2i(40, 240)

	logoImage = Image.Load(Get('scriptsdir')+sys.sep+'AS3Export.png')
	Draw.Image(logoImage, 40, 155)
	
	as_package_name = Draw.String("Package name: ", EVENT_NOEVENT, 40, 130, 250, 20, as_package_name.val, 300)
	engine_name = "Away3D%x1|Away3D 2.1.0%x5|Away3D 2.2.0%x6|Papervision3D%x2|Papervision3D 2.0%x3|Sandy 3.0%x4"
	engine_menu = Draw.Menu(engine_name, EVENT_NOEVENT, 40, 100, 200, 20, engine_menu.val, "Choose your engine")

	fileButton = Draw.String('File location: ', EVENT_NOEVENT, 40, 70, 250, 20, fileButton.val, 255) 
	Draw.PushButton('...', EVENT_BROWSEFILE, 300, 70, 30, 20, 'browse file')
	export_all = Draw.Toggle('Export ALL scene objects', EVENT_NOEVENT, 40, 45, 200, 20, 0)
	######### Draw and Exit Buttons
	Draw.Button("Export",EVENT_EXPORT , 40, 20, 80, 18)
	Draw.Button("Exit",EVENT_EXIT , 140, 20, 80, 18)

Draw.Register(draw, event, bevent)