/******************************************************************************
 * Spine Runtimes Software License
 * Version 2.1
 *
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 *
 * You are granted a perpetual, non-exclusive, non-sublicensable and
 * non-transferable license to install, execute and perform the Spine Runtimes
 * Software (the "Software") solely for internal use. Without the written
 * permission of Esoteric Software (typically granted by licensing Spine), you
 * may not (a) modify, translate, adapt or otherwise create derivative works,
 * improvements of the Software or develop new applications using the Software
 * or (b) remove, delete, alter or obscure any trademarks or any copyright,
 * trademark, patent or other intellectual property or proprietary rights
 * notices on or in the Software, including any copy thereof. Redistributions
 * in binary or source form must include this license and terms.
 *
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/
package spinehaxe;

import spinehaxe.Exception;

class BoneData {
	var _index:Int;
	var _name:String;
	var _parent:BoneData;
	public var index(get, never):Int;
	public var name(get, never):String;
	public var parent(get, never):BoneData;

	public var length:Float = 0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var rotation:Float = 0;
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var shearX:Float = 0;
	public var shearY:Float = 0;
	public var transformMode:TransformMode = TransformMode.normal;

	/** @param parent May be null. */
	public function new(index:Int, name:String, parent:BoneData) {
		if (index < 0) throw "index must be >= 0";
		if (name == null) throw "name cannot be null.";
		_index = index;
		_name = name;
		_parent = parent;
	}

	inline function get_index():Int return _index;

	inline function get_name():String return _name;

	inline function get_parent():BoneData return _parent;

	public function toString():String {
		return name;
	}
}
