////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.graphics
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Matrix;

import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

use namespace mx_internal;

[DefaultProperty("entries")]

/**
 *  The GradientBase class is the base class for
 *  LinearGradient, LinearGradientStroke, and RadialGradient.
 */
public class GradientBase extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 */
	public function GradientBase() 
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

 	/**
	 *  @private
	 */
	mx_internal var colors:Array /* of uint */ = [];

 	/**
	 *  @private
	 */
	mx_internal var ratios:Array /* of Number */ = [];

 	/**
	 *  @private
	 */
	mx_internal var alphas:Array /* of Number */ = [];
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
    //  angle
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the angle property.
     */
    mx_internal var _angle:Number;
    
    [Inspectable(category="General")]
	[Deprecated(replacement="rotation")]
    /**
     *  By default, the LinearGradientStroke defines a transition
     *  from left to right across the control. 
     *  Use the <code>angle</code> property to control the transition direction. 
     *  For example, a value of 180.0 causes the transition
     *  to occur from right to left, rather than from left to right.
     *
     *  @default 0.0
     */
    public function get angle():Number
    {
        return _angle / Math.PI * 180;
    }

    /**
     *  @private
     */
    public function set angle(value:Number):void
    {
        var oldValue:Number = _angle;
        _angle = value / 180 * Math.PI;
        
        mx_internal::dispatchGradientChangedEvent(
                            "angle", oldValue, _angle);
    }  

	//----------------------------------
	//  entries
	//----------------------------------

 	/**
	 *  @private
	 *  Storage for the entries property.
	 */
	private var _entries:Array = [];
	
	[Bindable("propertyChange")]
    [Inspectable(category="General", arrayType="mx.graphics.GradientEntry")]

	/**
	 *  An Array of GradientEntry objects
	 *  defining the fill patterns for the gradient fill.
	 *
	 *  @default []
	 */
	public function get entries():Array
	{
		return _entries;
	}

 	/**
	 *  @private
	 */
	public function set entries(value:Array):void
	{
		var oldValue:Array = _entries;
		_entries = value;
		
		processEntries();
		
		dispatchGradientChangedEvent("entries", oldValue, value);
	}
	
	//----------------------------------
    //  interpolationMethod
    //----------------------------------

    /**
     *  @private
     *  Storage for the interpolationMethod property.
     */
    private var _interpolationMethod:String = "rgb";
    
    [Inspectable(category="General", enumeration="rgb,linearRGB", defaultValue="rgb")]

    /**
     *  A value from the InterpolationMethod class
     *  that specifies which interpolation method to use.
     *
     *  <p>Valid values are <code>InterpolationMethod.LINEAR_RGB</code>
     *  and <code>InterpolationMethod.RGB</code>.</p>
     *  
     *  @default InterpolationMethod.RGB
     */
    public function get interpolationMethod():String
    {
        return _interpolationMethod;
    }
    
    /**
     *  @private
     */
    public function set interpolationMethod(value:String):void
    {
        var oldValue:String = _interpolationMethod;
        if (value != oldValue)
        {
            _interpolationMethod = value;
            
            dispatchGradientChangedEvent("interpolationMethod", oldValue, value);
        }
    }
    
    //----------------------------------
    //  matrix
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the matrix property.
     */
    private var _matrix:Matrix;
    
    [Inspectable(category="General")]

    /**
     *  By default, the LinearGradientStroke defines a transition
     *  from left to right across the control. 
     *  Use the <code>rotation</code> property to control the transition direction. 
     *  For example, a value of 180.0 causes the transition
     *  to occur from right to left, rather than from left to right.
     *
     *  @default 0.0
     */
    public function get matrix():Matrix
    {
        return _matrix;
    }

    /**
     *  @private
     */
    public function set matrix(value:Matrix):void
    {
    	var oldValue:Matrix = _matrix;
       	_matrix = value.clone();
       	
       	// TODO!!! Handle overriding the rotation, x, y, scaleX, scaleY values
       	dispatchGradientChangedEvent("matrix", oldValue, _matrix);
    }
    
    //----------------------------------
    //  rotation
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the rotation property.
     */
    private var _rotation:Number = 0.0;
    
    [Inspectable(category="General")]

    /**
     *  By default, the LinearGradientStroke defines a transition
     *  from left to right across the control. 
     *  Use the <code>rotation</code> property to control the transition direction. 
     *  For example, a value of 180.0 causes the transition
     *  to occur from right to left, rather than from left to right.
     *
     *  @default 0.0
     */
    public function get rotation():Number
    {
        return _rotation;
    }

    /**
     *  @private
     */
    public function set rotation(value:Number):void
    {
        var oldValue:Number = _rotation;  
        if (value != oldValue)
        {
        	_rotation = value;
        	dispatchGradientChangedEvent("rotation", oldValue, value);
        }
    }

    
    //----------------------------------
	//  scaleX
	//----------------------------------
	
    private var _scaleX:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The horizontal scale of the gradient transform, which defines the width of the (unrotated) gradient
     */
    public function get scaleX():Number
    {
    	return _scaleX;	
    }
    
	/**
	 *  @private
	 */
    public function set scaleX(value:Number):void
    {
    	var oldValue:Number = _scaleX;
    	if (value != oldValue)
    	{
    		_scaleX = value;
    		dispatchGradientChangedEvent("scaleX", oldValue, value);
    	}
    }
    
	//----------------------------------
	//  spreadMethod
	//----------------------------------
	
	/**
     *  @private
     *  Storage for the spreadMethod property.
     */
    private var _spreadMethod:String = "pad";
    
    [Bindable("propertyChange")]
    [Inspectable(category="General", enumeration="pad,reflect,repeat", defaultValue="pad")]

    /**
     *  A value from the SpreadMethod class
     *  that specifies which spread method to use.
     *
     *  <p>Value values are <code>SpreadMethod.PAD</code>, 
     *  <code>SpreadMethod.REFLECT</code>,
     *  and <code>SpreadMethod.REPEAT</code>.</p>
     *  
     *  @default SpreadMethod.PAD
     */
    public function get spreadMethod():String
    {
        return _spreadMethod;
    }
    
    /**
     *  @private
     */
    public function set spreadMethod(value:String):void
    {
        var oldValue:String = _spreadMethod;
        if (value != oldValue)
        {
            _spreadMethod = value;    
            dispatchGradientChangedEvent("spreadMethod", oldValue, value);
        }
    }
    
    //----------------------------------
	//  x
	//----------------------------------
	
    private var _x:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
    /**
     *  The distance by which to translate each point along the x axis.
     */
    public function get x():Number
    {
    	return _x;	
    }
    
	/**
	 *  @private
	 */
    public function set x(value:Number):void
    {
    	var oldValue:Number = _x;
    	if (value != oldValue)
    	{
    		_x = value;
    		dispatchGradientChangedEvent("x", oldValue, value);
    	}
    }
    
    //----------------------------------
	//  y
	//----------------------------------
    
    private var _y:Number;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]
    
     /**
     *  The distance by which to translate each point along the y axis.
     */
    public function get y():Number
    {
    	return _y;	
    }
    
    /**
     *  @private
     */
    public function set y(value:Number):void
    {
    	var oldValue:Number = _y;
    	if (value != oldValue)
    	{
    		_y = value;
    		dispatchGradientChangedEvent("y", oldValue, value);
    	}
    }
    
    mx_internal function get rotationInRadians():Number
    {
    	return _rotation / 180 * Math.PI;
    }

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Extract the gradient information in the public <code>entries</code>
	 *  Array into the internal <code>colors</code>, <code>ratios</code>,
	 *  and <code>alphas</code> arrays.
	 */
	private function processEntries():void
	{
		colors = [];
		ratios = [];
		alphas = [];

		if (!_entries || _entries.length == 0)
			return;

		var ratioConvert:Number = 255;

		var i:int;
		
		var n:int = _entries.length;
		for (i = 0; i < n; i++)
		{
			var e:GradientEntry = _entries[i];
			e.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, 
							   entry_propertyChangeHandler, false, 0, true);
			colors.push(e.color);
			alphas.push(e.alpha);
			ratios.push(e.ratio * ratioConvert);
		}
		
		if (isNaN(ratios[0]))
			ratios[0] = 0;
			
		if (isNaN(ratios[n - 1]))
			ratios[n - 1] = 255;
		
		i = 1;

		while (true)
		{
			while (i < n && !isNaN(ratios[i]))
			{
				i++;
			}

			if (i == n)
				break;
				
			var start:int = i - 1;
			
			while (i < n && isNaN(ratios[i]))
			{
				i++;
			}
			
			var br:Number = ratios[start];
			var tr:Number = ratios[i];
			
			for (var j:int = 1; j < i - start; j++)
			{
				ratios[j] = br + j * (tr - br) / (i - start);
			}
		}
	}

	/**
	 *  Dispatch a gradientChanged event.
	 */
	mx_internal function dispatchGradientChangedEvent(prop:String,
													  oldValue:*, value:*):void
	{
		dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
															oldValue, value));
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function entry_propertyChangeHandler(event:Event):void
	{
		processEntries();

		dispatchGradientChangedEvent("entries", entries, entries);
	}
}

}
