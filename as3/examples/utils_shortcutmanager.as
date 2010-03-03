/*

Desuade Utilities Package - Shortcut Example

http://desuade.com/

This .fla goes over how to use the Shortcut class

////Overview////

The Shortcut class provides an easy way to asign keyboard shortcuts to methods inside your movie

There are 2 kinds of shortcuts available:

Combos: 1 or more keys need to be pressed (or held) at the same time
Sequences: a sequence of keys needs to be pressed to activate the method

Combos are what most operating systems use, such as control-z, or shift-apple-t
Sequences are more like video game cheat codes: a, b, a, b, up, down

A variation combos is the ability to wait for the keys to be held, so "hold a and b down together for 2 seconds".

////Useage////

Create a Shortcut object, passing the stage:

var sc:Shortcut = new Shortcut(stage);

Then add whatever shortcuts you want with the given methods:

sc.addKeyCombo(label, keys, method, hold);
sc.addKeySequence(label, keys, method);

For more information, consult the docs on properties and syntax guidelines: http://api.desuade.com/

*/

package {

	import flash.display.*;
	
	public class utils_shortcutmanager extends MovieClip {
	
		public function utils_shortcutmanager()
		{
			super();

			import com.desuade.utils.ShortcutManager;

			var scm:ShortcutManager = new ShortcutManager(stage); //create the ShortcutManager
			scm.traceKeys = true; //show us key activity, useful to figure out codes for the key array
			scm.addKeyCombo('hello', [72, 87], hworld); //add a regular combo (press h & w keys)
			//add a combo that needs to be held (press d & h & w keys for 2 seconds)
			scm.addKeyCombo('hellohold', [72, 87, 68], hworldhold, 2000);
			scm.addKeySequence('helloseq', [81, 87, 69, 82, 84, 89], hworlds); //adds a key sequence in order of pressed (type: qwerty)

			//methods to call
			function hworld(){
				trace('hello combo world!');
			}

			function hworldhold(){
				trace('...taking a while to say hello combo world!');
			}

			function hworlds(){
				trace('hello from a qwerty sequence shortcut!');
			}
			
			
			
		}
	
	}

}

