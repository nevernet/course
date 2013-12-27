/**
 * timer.js
 *
 * @author Dreamszhu dreamsxin@qq.com
 * @date 2013-12-27
 */

;(function($) {
	$.timer = function(options) {
		this.currentTime = 0;
		options = $.extend({
			play: null,
			pause: null,
			stop: null,
			update: null,
			once: null,
			intervalTime: 70
		}, options);
	 	this.set = function(options) {
	 		this.init = true;
		 	if(options.autostart && !this.isActive) {
			 	this.isActive = true;
			 	this.setTimer();
		 	}
		 	return this;
	 	};
	 	this.once = function(time) {
			var timer = this;
			window.setTimeout(function() {
				if(options.update) {
					options.update();
				}
			}, time);
	 		return this;
	 	};
		this.play = function(reset) {
			if(!this.isActive) {
				if(reset) {
					this.currentTime = 0;
				}
				this.setTimer(options.intervalTime);
				this.isActive = true;
				if(options.play) {
					options.play();
				}
			}
			return this;
		};
		this.stop = function() {
			this.isActive = false;
			this.clearTimer();
			if(options.stop) {
				options.stop();
			}
			return this;
		};
		this.toggle = function(reset) {
			if(this.isActive) {
				this.pause();				
			} else if(reset) {
				this.play(true);
			} else {
				this.play();
			}
			return this;
		};
		this.clearTimer = function() {
			window.clearTimeout(this.timeoutObject);
		};
	 	this.setTimer = function(time) {
			var timer = this;
	 	 	this.last = new Date();
			this.clearTimer();
			this.timeoutObject = window.setTimeout(function() {
				timer.go();
			}, time);
		};
	 	this.go = function() {
	 		if(this.isActive) {
				this.currentTime += options.intervalTime / 10 ;
				
				if(options.update) {
					options.update();
				}

	 			this.setTimer(options.intervalTime);
	 		}
	 	};
	 	
	 	if(this.init) {
	 		return new $.timer(options);
	 	} else {
			this.set(options);
	 		return this;
	 	}
	};
})(jQuery);