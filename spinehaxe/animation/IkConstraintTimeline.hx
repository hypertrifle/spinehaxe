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

package spinehaxe.animation;

import spinehaxe.Event;
import spinehaxe.IkConstraint;
import spinehaxe.Skeleton;
import openfl.Vector;

class IkConstraintTimeline extends CurveTimeline {
	inline static var PREV_FRAME_TIME:Int = -3;
	inline static var PREV_FRAME_MIX:Int = -2;
	inline static var PREV_FRAME_BEND_DIRECTION:Int = -1;
	inline static var FRAME_MIX:Int = 1;

	public var ikConstraintIndex:Int;
	public var frames:Vector<Float>; // time, mix, bendDirection, ...

	public function new (frameCount:Int) {
		super(frameCount);
		frames = ArrayUtils.allocFloat(frameCount * 3, true);
	}

	/** Sets the time, mix and bend direction of the specified keyframe. */
	public function setFrame (frameIndex:Int, time:Float, mix:Float, bendDirection:Int) : Void {
		frameIndex *= 3;
		frames[frameIndex] = time;
		frames[frameIndex + 1] = mix;
		frames[frameIndex + 2] = bendDirection;
	}

	override public function apply (skeleton:Skeleton, lastTime:Float, time:Float, firedEvents:Array<Event>, alpha:Float) : Void {
		if (time < frames[0]) return; // Time is before first frame.

		var ikConstraint:IkConstraint = skeleton.ikConstraints[ikConstraintIndex];

		if (time >= frames[frames.length - 3]) { // Time is after last frame.
			ikConstraint.mix += (frames[frames.length - 2] - ikConstraint.mix) * alpha;
			ikConstraint.bendDirection = Std.int(frames[frames.length - 1]);
			return;
		}

		// Interpolate between the previous frame and the current frame.
		var frameIndex:Int = Animation.binarySearch(frames, time, 3);
		var prevFrameMix:Float = frames[frameIndex + PREV_FRAME_MIX];
		var frameTime:Float = frames[frameIndex];
		var percent:Float = 1 - (time - frameTime) / (frames[frameIndex + PREV_FRAME_TIME] - frameTime);
		percent = getCurvePercent(Std.int(frameIndex / 3 - 1), percent < 0 ? 0 : (percent > 1 ? 1 : percent));

		var mix:Float = prevFrameMix + (frames[frameIndex + FRAME_MIX] - prevFrameMix) * percent;
		ikConstraint.mix += (mix - ikConstraint.mix) * alpha;
		ikConstraint.bendDirection = Std.int(frames[frameIndex + PREV_FRAME_BEND_DIRECTION]);
	}
}
