; ---------------------------------------------------------------------------
; Solid object subroutines (includes spikes, blocks, rocks etc)
; These check collision of Sonic/Tails with objects on the screen
;
; input variables:
; d1 = object width / 2
; d2 = object height / 2 (when jumping)
; d3 = object height / 2 (when walking)
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_19718:
SolidObject:
	; Collide player 1.
	lea	(MainCharacter).w,a1
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)	; Backup input registers.
	bsr.s	+
	movem.l	(sp)+,d1-d4	; Restore input registers.

	; Collide player 2.
	lea	(Sidekick).w,a1
	tst.b	render_flags(a1)
	bpl.w	return_19776	; Don't bother if Tails is not on-screen.
	addq.b	#p2_standing_bit-p1_standing_bit,d6
+
	btst	d6,status(a0)
	beq.w	SolidObject_OnScreenTest
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_1975A
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_1975A
	cmp.w	d2,d0
	blo.s	loc_1976E

loc_1975A:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_1976E:
	move.w	d4,d2
	bsr.w	MvSonicOnPtfm
	moveq	#0,d4

return_19776:
	rts

; ===========================================================================
; there are a few slightly different SolidObject functions
; specialized for certain objects, in this case, obj74 and obj30
; These check for solidity even if the object is off-screen
; loc_19778: SolidObject74_30:
SolidObject_Always:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	SolidObject_Always_SingleCharacter
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
;loc_1978E:
SolidObject_Always_SingleCharacter:
	btst	d6,status(a0)
	beq.w	SolidObject_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_197B2
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_197B2
	cmp.w	d2,d0
	blo.s	loc_197C6

loc_197B2:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_197C6:
	move.w	d4,d2
	bsr.w	MvSonicOnPtfm
	moveq	#0,d4
	rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a sloped solid like diagonal springs
; ---------------------------------------------------------------------------
;
; input variables:
; d1 = object width
; d2 = object height / 2 (when jumping)
; d3 = object height / 2 (when walking)
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; a2 = height data for slope
; loc_197D0: SolidObject86_30:
SlopedSolid:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	SlopedSolid_SingleCharacter
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6

; this gets called from a few more places...
; loc_197E6: SolidObject_Simple:
SlopedSolid_SingleCharacter:
	btst	d6,status(a0)
	beq.w	SlopedSolid_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_1980A
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_1980A
	cmp.w	d2,d0
	blo.s	loc_1981E

loc_1980A:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_1981E:
	move.w	d4,d2
	bsr.w	MvSonicOnSlope
	moveq	#0,d4
	rts

; ===========================================================================
; unused/dead code for some SolidObject check
; This is for a sloped object that is sloped at the top and at the bottom.
; SolidObject_Unk: loc_19828:
;DoubleSlopedSolid:
	; a0=object
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	+
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
+
	btst	d6,status(a0)
	beq.w	DoubleSlopedSolid_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_19862
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_19862
	cmp.w	d2,d0
	blo.s	loc_19876

loc_19862:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_19876:
	move.w	d4,d2
	bsr.w	MvSonicOnDoubleSlope
	moveq	#0,d4
	rts

; ===========================================================================
; loc_19880:
SolidObject45:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	loc_19896
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6

loc_19896:
	btst	d6,status(a0)
	beq.w	SolidObject45_cont
	btst	#1,status(a1)
	bne.s	loc_198B8
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_198B8
	add.w	d1,d1
	cmp.w	d1,d0
	blo.s	loc_198CC

loc_198B8:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_198CC:
	; Inlined call to MvSonicOnPtfm
	move.w	y_pos(a0),d0
	sub.w	d2,d0
	add.w	d3,d0
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	sub.w	x_pos(a0),d4
	sub.w	d4,x_pos(a1)
	moveq	#0,d4
	rts
; ===========================================================================
; loc_198EC: SolidObject45_alt:
SolidObject45_cont:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	SolidObject_TestClearPush
	move.w	d1,d4
	add.w	d4,d4
	cmp.w	d4,d0
	bhi.w	SolidObject_TestClearPush
	move.w	y_pos(a0),d5
	add.w	d3,d5
	move.b	y_radius(a1),d3
	ext.w	d3
	add.w	d3,d2
	move.w	y_pos(a1),d3
	sub.w	d5,d3
	addq.w	#4,d3
	add.w	d2,d3
	bmi.w	SolidObject_TestClearPush
	move.w	d2,d4
	add.w	d4,d4
	cmp.w	d4,d3
	bhs.w	SolidObject_TestClearPush
	bra.w	SolidObject_ChkBounds
; ===========================================================================
; loc_1992E: SolidObject86_30_alt:
SlopedSolid_cont:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	SolidObject_TestClearPush
	move.w	d1,d3
	add.w	d3,d3
	cmp.w	d3,d0
	bhi.w	SolidObject_TestClearPush
	move.w	d0,d5
	btst	#0,render_flags(a0)
	beq.s	+
	not.w	d5
	add.w	d3,d5
+
	lsr.w	#1,d5
	move.b	(a2,d5.w),d3
	sub.b	(a2),d3
	ext.w	d3
	move.w	y_pos(a0),d5
	sub.w	d3,d5
	move.b	y_radius(a1),d3
	ext.w	d3
	add.w	d3,d2
	move.w	y_pos(a1),d3
	sub.w	d5,d3
	addq.w	#4,d3
	add.w	d2,d3
	bmi.w	SolidObject_TestClearPush
	move.w	d2,d4
	add.w	d4,d4
	cmp.w	d4,d3
	bhs.w	SolidObject_TestClearPush
	bra.w	SolidObject_ChkBounds
; ===========================================================================
; unused/dead code
; loc_19988: SolidObject_Unk_cont:
DoubleSlopedSolid_cont:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	SolidObject_TestClearPush
	move.w	d1,d3
	add.w	d3,d3
	cmp.w	d3,d0
	bhi.w	SolidObject_TestClearPush
	move.w	d0,d5
	btst	#0,render_flags(a0)
	beq.s	+
	not.w	d5
	add.w	d3,d5
+
	andi.w	#$FFFE,d5
	move.b	(a2,d5.w),d3
	move.b	1(a2,d5.w),d2
	ext.w	d2
	ext.w	d3
	move.w	y_pos(a0),d5
	sub.w	d3,d5
	move.w	y_pos(a1),d3
	sub.w	d5,d3
	move.b	y_radius(a1),d5
	ext.w	d5
	add.w	d5,d3
	addq.w	#4,d3
	bmi.w	SolidObject_TestClearPush
	add.w	d5,d2
	move.w	d2,d4
	add.w	d5,d4
	cmp.w	d4,d3
	bhs.w	SolidObject_TestClearPush
	bra.w	SolidObject_ChkBounds
; ===========================================================================
; loc_199E8: SolidObject_cont:
SolidObject_OnScreenTest:
	; If the object is not on-screen, then don't try to collide with it.
	; This is presumably an optimisation, but this means that if Sonic
	; outruns the screen then he can phase through solid objects.
	tst.b	render_flags(a0)
	bpl.w	SolidObject_TestClearPush
;loc_199F0:
SolidObject_cont:
	; We now perform the X portion of a bounding box check. To do this, we assume a
	; coordinate system where the X origin is at the object's left edge.
	move.w	x_pos(a1),d0			; load Sonic's X position...
	sub.w	x_pos(a0),d0			; ...and calculate his x position relative to the object.
	add.w	d1,d0				; Put object's left edge at (0,0).  This is also Sonic's distance to the object's left edge.
	bmi.w	SolidObject_TestClearPush	; Branch if Sonic is outside the object's left edge.
	move.w	d1,d3
	add.w	d3,d3				; Calculate object's width.
	cmp.w	d3,d0
	bhi.w	SolidObject_TestClearPush	; Branch if Sonic is outside the object's right edge.
	; We now perform the y portion of a bounding box check. To do this, we assume a
	; coordinate system where the y origin is at the highest y position relative to the object
	; at which Sonic would still collide with it.  This point is
	;   y_pos(object) - width(object)/2 - y_radius(Sonic) - 4,
	; where object is stored in (a0), Sonic in (a1), and height(object)/2 in d2.  This way
	; of doing it causes the object's hitbox to be vertically off-center by -4 pixels.
	move.b	y_radius(a1),d3			; load Sonic's Y radius.
	ext.w	d3
	add.w	d3,d2				; Calculate maximum distance for a top collision.
	move.w	y_pos(a1),d3			; load Sonic's y position...
	sub.w	y_pos(a0),d3			; ...and calculate his y position relative to the object.
	addq.w	#4,d3				; Assume a slightly lower position for Sonic.
	add.w	d2,d3				; Make the highest position where Sonic would still be colliding with the object (0,0).
	bmi.w	SolidObject_TestClearPush	; Branch if Sonic is above this point.
	andi.w	#$7FF,d3
	move.w	d2,d4
	add.w	d4,d4				; Calculate minimum distance for a bottom collision.
	cmp.w	d4,d3
	bhs.w	SolidObject_TestClearPush	; Branch if Sonic is below this point.
;loc_19A2E:
SolidObject_ChkBounds:
	tst.b	obj_control(a1)
	bmi.w	SolidObject_TestClearPush	; Branch if object collisions are disabled for Sonic.
	cmpi.b	#6,routine(a1)			; Is Sonic dead?
	bhs.w	SolidObject_NoCollision		; If yes, branch.
	tst.w	(Debug_placement_mode).w
	bne.w	SolidObject_NoCollision		; Branch if in Debug Mode.

	move.w	d0,d5
	cmp.w	d0,d1
	bhs.s	.isToTheLeft		; Branch if Sonic is to the object's left.

;.isToTheRight:
	add.w	d1,d1
	sub.w	d1,d0
	move.w	d0,d5			; Calculate Sonic's distance to the object's right edge...
	neg.w	d5			; ...and calculate the absolute value.

.isToTheLeft:
	move.w	d3,d1
	cmp.w	d3,d2
	bhs.s	.isAbove

;.isBelow:
	subq.w	#4,d3
	sub.w	d4,d3
	move.w	d3,d1
	neg.w	d1

.isAbove:
	; Now...
	; 'd0' contains Sonic's distance to the nearest object horizontal edge.
	; 'd5' contains the absolute version of 'd0'.
	; 'd3' contains Sonic's distance to the nearest object vertical edge.
	; 'd1' contains the absolute version of 'd3'.
	cmp.w	d1,d5
	bhi.w	SolidObject_TopBottom		; Branch, if horizontal distance is greater than vertical distance.
; loc_19A6A:
SolidObject_LeftRight:
	; If Sonic is extremely close to the top or bottom, then branch.
	; I guess the point of this is to let Sonic walk over objects that
	; are barely poking out of the ground?
	cmpi.w	#4,d1
	bls.s	SolidObject_SideAir

	tst.w	d0			; Where is Sonic?
	beq.s	SolidObject_AtEdge	; If at the object's edge, branch
	bmi.s	SolidObject_InsideRight	; If in the right side of the object, branch

;SolidObject_InsideLeft:
	tst.w	x_vel(a1)		; Is Sonic moving left?
	bmi.s	SolidObject_AtEdge	; If yes, branch
	bra.s	SolidObject_StopCharacter
; ===========================================================================
; loc_19A7E:
SolidObject_InsideRight:
	tst.w	x_vel(a1)		; is Sonic moving right?
	bpl.s	SolidObject_AtEdge	; if yes, branch
; loc_19A84:
SolidObject_StopCharacter:
	move.w	#0,inertia(a1)
	move.w	#0,x_vel(a1)		; stop Sonic moving
; loc_19A90:
SolidObject_AtEdge:
	sub.w	d0,x_pos(a1)		; correct Sonic's position
	btst	#1,status(a1)		; is Sonic in the air?
	bne.s	SolidObject_SideAir	; if yes, branch
	move.l	d6,d4
	addq.b	#pushing_bit_delta,d4	; Character is pushing, not standing
	bset	d4,status(a0)		; make object be pushed
	bset	#5,status(a1)		; make Sonic push object
	move.w	d6,d4
	addi.b	#($10-p1_standing_bit+p1_touch_side_bit),d4
	bset	d4,d6	; This sets bits 0 (Sonic) or 1 (Tails) of high word of d6
	moveq	#1,d4	; return side collision
	rts
; ===========================================================================
; loc_19AB6:
SolidObject_SideAir:
	bsr.s	Solid_NotPushing
	move.w	d6,d4
	addi.b	#($10-p1_standing_bit+p1_touch_side_bit),d4
	bset	d4,d6	; This sets bits 0 (Sonic) or 1 (Tails) of high word of d6
	moveq	#1,d4	; return side collision
	rts
; ===========================================================================
;loc_19AC4:
SolidObject_TestClearPush:
	move.l	d6,d4
	addq.b	#pushing_bit_delta,d4
	btst	d4,status(a0)		; is Sonic pushing?
	beq.s	SolidObject_NoCollision	; if not, branch
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	beq.s	Solid_NotPushing
    if fixBugs
	; Prevent Sonic or Tails from entering their running animation when
	; stood next to solid objects while charging a Spin Dash, dying, or
	; drowning. One way to see this bug is by charging a Spin Dash while
	; next to one of Mystic Cave Zone's crushing pillars.
	cmpi.b	#AniIDSonAni_Spindash,anim(a1)
	beq.s	Solid_NotPushing
	cmpi.b	#AniIDSonAni_Death,anim(a1)
	beq.s	Solid_NotPushing
	cmpi.b	#AniIDSonAni_Drown,anim(a1)
	beq.s	Solid_NotPushing
    endif
	move.w	#(AniIDSonAni_Walk<<8)|(AniIDSonAni_Run<<0),anim(a1) ; use walking animation (and force it to restart)
; loc_19ADC:
Solid_NotPushing:
	move.l	d6,d4
	addq.b	#pushing_bit_delta,d4
	bclr	d4,status(a0)	; clear pushing flag
	bclr	#5,status(a1)	; clear Sonic's pushing flag
; loc_19AEA:
SolidObject_NoCollision:
	moveq	#0,d4	; return no collision
	rts
; ===========================================================================
; loc_19AEE:
SolidObject_TopBottom:
	tst.w	d3				; is Sonic below the object?
	bmi.s	SolidObject_InsideBottom	; if yes, branch

;SolidObject_InsideTop:
	cmpi.w	#$10,d3				; has Sonic landed on the object?
	blo.s	SolidObject_Landed		; if yes, branch
	cmpi.b	#ObjID_LauncherSpring,id(a0)
	bne.s	SolidObject_TestClearPush
	cmpi.w	#$14,d3				; has Sonic landed on the object?
	blo.s	SolidObject_Landed		; if yes, branch
	bra.s	SolidObject_TestClearPush
; ===========================================================================
; loc_19B06:
SolidObject_InsideBottom:
	tst.w	y_vel(a1)		; is Sonic moving vertically?
	beq.s	SolidObject_Squash	; if not, branch
	bpl.s	loc_19B1C		; if moving downwards, branch
	tst.w	d3			; is Sonic above the object?
	bpl.s	loc_19B1C		; if yes, branch (this will never be true)
    if ~~fixBugs
	; This is in the wrong place: Sonic will not be pushed out of objects
	; from above if he's not moving upwards against it!
	; This is much more noticable when playing as Knuckles, as he'll be
	; able to phase through objects when climbing up walls.
	; 'Knuckles in Sonic 2' and 'Sonic 3 & Knuckles' tried to fix this,
	; but didn't do it very well.
	sub.w	d3,y_pos(a1)		; Push Sonic out of the object.
    endif
	move.w	#0,y_vel(a1)		; Stop Sonic from moving.

loc_19B1C:
    if fixBugs
	; See above.
	sub.w	d3,y_pos(a1)		; Push Sonic out of the object.
    endif
	move.w	d6,d4
	addi.b	#($10-p1_standing_bit+p1_touch_bottom_bit),d4
	bset	d4,d6	; This sets bits 2 (Sonic) or 3 (Tails) of high word of d6
	moveq	#-2,d4			; Return bottom collision.
	rts
; ===========================================================================
; loc_19B28:
SolidObject_Squash:
	btst	#1,status(a1)	; is Sonic in the air?
	bne.s	loc_19B1C	; if yes, branch
	mvabs.w	d0,d4

	; Hey, look: it's the two lines of code that the Taxman/Stealth
	; remasters forgot to copy.
	; If Sonic is near the left or right edge of the object, then don't
	; kill him, instead just push him away horizontally.
	cmpi.w	#$10,d4
	blo.w	SolidObject_LeftRight

	move.l	a0,-(sp)
    if fixBugs
	; a2 needs to be set here, otherwise KillCharacter
	; will access a dangling pointer!
	movea.l	a0,a2
    endif
	movea.l	a1,a0
	jsr	(KillCharacter).l
	movea.l	(sp)+,a0 ; load 0bj address
	move.w	d6,d4
	addi.b	#($10-p1_standing_bit+p1_touch_bottom_bit),d4
	bset	d4,d6	; This sets bits 2 (Sonic) or 3 (Tails) of high word of d6
	moveq	#-2,d4			; Return bottom collision.
	rts
; ===========================================================================
; loc_19B56:
SolidObject_Landed:
	subq.w	#4,d3
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	d1,d2
	add.w	d2,d2
	add.w	x_pos(a1),d1
	sub.w	x_pos(a0),d1
	bmi.s	SolidObject_Miss	; if Sonic is right of object, branch
	cmp.w	d2,d1			; is Sonic left of object?
	bhs.s	SolidObject_Miss	; if yes, branch
	tst.w	y_vel(a1)		; is Sonic moving upwards?
	bmi.s	SolidObject_Miss	; if yes, branch
	sub.w	d3,y_pos(a1)		; correct Sonic's position
	subq.w	#1,y_pos(a1)
	bsr.w	RideObject_SetRide
	move.w	d6,d4
	addi.b	#($10-p1_standing_bit+p1_touch_top_bit),d4
	bset	d4,d6	; This sets bits 4 (Sonic) or 5 (Tails) of high word of d6
	moveq	#-1,d4			; return top collision
	rts
; ===========================================================================
; loc_19B8E:
SolidObject_Miss:
	moveq	#0,d4	; return no collision
	rts
; ===========================================================================

; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_19B92:

MvSonicOnPtfm:
	move.w	y_pos(a0),d0
	sub.w	d3,d0
	bra.s	loc_19BA2
; ===========================================================================
	; a couple lines of unused/leftover/dead code from Sonic 1 ; a0=object
	move.w	y_pos(a0),d0
	subi.w	#9,d0

loc_19BA2:
	tst.b	obj_control(a1)
	bmi.s	return_19BCA
	cmpi.b	#6,routine(a1)
	bhs.s	return_19BCA
	tst.w	(Debug_placement_mode).w
	bne.s	return_19BCA
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	sub.w	x_pos(a0),d2
	sub.w	d2,x_pos(a1)

return_19BCA:
	rts
; ===========================================================================
;loc_19BCC:
MvSonicOnSlope:
	btst	#3,status(a1)
	beq.s	return_19C0C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	lsr.w	#1,d0
	btst	#0,render_flags(a0)
	beq.s	loc_19BEC
	not.w	d0
	add.w	d1,d0

loc_19BEC:
	move.b	(a2,d0.w),d1
	ext.w	d1
	move.w	y_pos(a0),d0
	sub.w	d1,d0
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	sub.w	x_pos(a0),d2
	sub.w	d2,x_pos(a1)

return_19C0C:
	rts
; ===========================================================================
; unused/dead code.
; loc_19C0E:
MvSonicOnDoubleSlope:
	btst	#3,status(a1)
	beq.s	return_19C0C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	btst	#0,render_flags(a0)
	beq.s	loc_19C2C
	not.w	d0
	add.w	d1,d0

loc_19C2C:
	andi.w	#$FFFE,d0
	bra.s	loc_19BEC
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
;
; input variables:
; d1 = object width
; d3 = object height / 2
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; loc_19C32:
PlatformObject:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	PlatformObject_SingleCharacter
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
; loc_19C48:
PlatformObject_SingleCharacter:
	btst	d6,status(a0)
	beq.w	PlatformObject_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	+
	cmp.w	d2,d0
	blo.s	loc_19C80
+

	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_19C80:
	move.w	d4,d2
	bsr.w	MvSonicOnPtfm
	moveq	#0,d4
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a sloped platform like a seesaw
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
;
; input variables:
; d1 = object width
; d3 = object height
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = Sonic or Tails (set inside these subroutines)
; a2 = height data for slope
; loc_19C8A: SlopeObject:
SlopedPlatform:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	SlopedPlatform_SingleCharacter
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
; loc_19CA0:
SlopedPlatform_SingleCharacter:
	btst	d6,status(a0)
	beq.w	SlopedPlatform_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_19CC4
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_19CC4
	cmp.w	d2,d0
	blo.s	loc_19CD8

loc_19CC4:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ---------------------------------------------------------------------------
loc_19CD8:
	move.w	d4,d2
	bsr.w	MvSonicOnSlope
	moveq	#0,d4
	rts
; ===========================================================================
; Identical to PlatformObject.
;loc_19CE2:
PlatformObject2:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	loc_19CF8
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6

loc_19CF8:
	btst	d6,status(a0)
	beq.w	PlatformObject2_cont
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_19D1C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_19D1C
	cmp.w	d2,d0
	blo.s	loc_19D30

loc_19D1C:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ===========================================================================

loc_19D30:
	move.w	d4,d2
	bsr.w	MvSonicOnPtfm
	moveq	#0,d4
	rts
; ===========================================================================
; Almost identical to PlatformObject, except that this function does nothing if
; the character is already standing on a platform. Used only by the elevators
; in CNZ.
;loc_19D3A:
PlatformObjectD5:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	loc_19D50
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6

loc_19D50:
	btst	d6,status(a0)
	bne.s	loc_19D62
	btst	#3,status(a1)
	bne.s	loc_19D8E
	bra.w	PlatformObject_cont
; ===========================================================================

loc_19D62:
	move.w	d1,d2
	add.w	d2,d2
	btst	#1,status(a1)
	bne.s	loc_19D7E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	loc_19D7E
	cmp.w	d2,d0
	blo.s	loc_19D92

loc_19D7E:
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	d6,status(a0)

loc_19D8E:
	moveq	#0,d4
	rts
; ===========================================================================

loc_19D92:
	move.w	d4,d2
	bsr.w	MvSonicOnPtfm
	moveq	#0,d4
	rts
; ===========================================================================
; Used only by EHZ/HPZ log bridges. Very similar to PlatformObject_cont, but
; d2 already has the full width of the log.
;loc_19D9C:
PlatformObject11_cont:
	tst.w	y_vel(a1)
	bmi.w	return_19E8E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	return_19E8E
	cmp.w	d2,d0
	bhs.w	return_19E8E
	bra.s	loc_19DD8
; ===========================================================================
;loc_19DBA:
PlatformObject_cont:
	tst.w	y_vel(a1)
	bmi.w	return_19E8E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	return_19E8E
	add.w	d1,d1
	cmp.w	d1,d0
	bhs.w	return_19E8E

loc_19DD8:
	move.w	y_pos(a0),d0
	sub.w	d3,d0
;loc_19DDE:
PlatformObject_ChkYRange:
	move.w	y_pos(a1),d2
	move.b	y_radius(a1),d1
	ext.w	d1
	add.w	d2,d1
	addq.w	#4,d1
	sub.w	d1,d0
	bhi.w	return_19E8E
	cmpi.w	#-$10,d0
	blo.w	return_19E8E
	tst.b	obj_control(a1)
	bmi.w	return_19E8E
	cmpi.b	#6,routine(a1)
	bhs.w	return_19E8E
	add.w	d0,d2
	addq.w	#3,d2
	move.w	d2,y_pos(a1)
;loc_19E14:
RideObject_SetRide:
	btst	#3,status(a1)
	beq.s	loc_19E30
	moveq	#0,d0
	move.b	interact(a1),d0
    if object_size=$40
	lsl.w	#object_size_bits,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	bclr	d6,status(a3)

loc_19E30:
    if object_size<>$40
	moveq	#0,d0 ; Clear the high word for the coming division.
    endif
	move.w	a0,d0
	subi.w	#Object_RAM,d0
    if object_size=$40
	lsr.w	#object_size_bits,d0
    else
	divu.w	#object_size,d0
    endif
	andi.w	#$7F,d0
	move.b	d0,interact(a1)
	move.b	#0,angle(a1)
	move.w	#0,y_vel(a1)
	move.w	x_vel(a1),inertia(a1)
	btst	#1,status(a1)
	beq.s	loc_19E7E
	move.l	a0,-(sp)
	movea.l	a1,a0
	move.w	a0,d1
	subi.w	#Object_RAM,d1
	bne.s	loc_19E76
	cmpi.w	#2,(Player_mode).w
	beq.s	loc_19E76
	jsr	(Sonic_ResetOnFloor_Part2).l
	bra.s	loc_19E7C
; ===========================================================================

loc_19E76:
	jsr	(Tails_ResetOnFloor_Part2).l

loc_19E7C:
	movea.l	(sp)+,a0 ; a0=character

loc_19E7E:
	bset	#3,status(a1)
	bclr	#1,status(a1)
	bset	d6,status(a0)

return_19E8E:
	rts
; ===========================================================================
;loc_19E90:
SlopedPlatform_cont:
	tst.w	y_vel(a1)
	bmi.w	return_19E8E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	return_19E8E
	add.w	d1,d1
	cmp.w	d1,d0
	bhs.s	return_19E8E
	btst	#0,render_flags(a0)
	beq.s	loc_19EB6
	not.w	d0
	add.w	d1,d0

loc_19EB6:
	lsr.w	#1,d0
	move.b	(a2,d0.w),d3
	ext.w	d3
	move.w	y_pos(a0),d0
	sub.w	d3,d0
	bra.w	PlatformObject_ChkYRange
; ===========================================================================
; Basically identical to PlatformObject_cont
;loc_19EC8:
PlatformObject2_cont:
	tst.w	y_vel(a1)
	bmi.w	return_19E8E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.w	return_19E8E
	add.w	d1,d1
	cmp.w	d1,d0
	bhs.w	return_19E8E
	move.w	y_pos(a0),d0
	sub.w	d3,d0
	bra.w	PlatformObject_ChkYRange
; ===========================================================================
; If a character is being dragged through terrain by this object, drop the
; character on terrain instead.
;loc_19EF0:
DropOnFloor:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#p1_standing_bit,status(a0)
	beq.s	loc_19F1E
	jsr	(ChkFloorEdge2).l
	tst.w	d1
	beq.s	loc_19F08
	bpl.s	loc_19F1E

loc_19F08:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	#p1_standing_bit,status(a0)

loc_19F1E:
	lea	(Sidekick).w,a1 ; a1=character
	btst	#p2_standing_bit,status(a0)
	beq.s	loc_19F4C
	jsr	(ChkFloorEdge2).l
	tst.w	d1
	beq.s	loc_19F36
	bpl.s	loc_19F4C

loc_19F36:
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#3,status(a1)
	bset	#1,status(a1)
	bclr	#p2_standing_bit,status(a0)

loc_19F4C:
	moveq	#0,d4
	rts

; There was linker data here in the September 14th prototype.
