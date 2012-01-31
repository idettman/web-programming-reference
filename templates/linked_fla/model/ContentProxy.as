package model
{
	import events.ApplicationEvent;

	import flash.events.EventDispatcher;


	public class ContentProxy extends EventDispatcher
	{
		private var _data:Array;// List of DataVo parsed from xml
		private var _xml:XML;


		/**
		 * Public Methods
		 */
		public function loadData():void
		{
			initXmlTestContent();
			parseXml();
			loadDataComplete();
		}
		
		
		private function loadDataComplete():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.MODEL_LOAD_DATA_COMPLETE, _data));
		}
		
		
		public function destroy():void
		{
			
		}


		/**
		 * Private/Protected
		 */
		private function parseXml():void
		{
			var item:XML;
			for each (item in _xml)
			{
				
			}
			
		}
		
		private function initXmlTestContent():void
		{
			_xml = <data>
						<content>
							<id>001</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>002</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>003</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>004</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>005</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>006</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>007</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>008</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>009</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
						<content>
							<id>010</id>
							<type><![CDATA[disclosure]]></type>
							<url><![CDATA[http://www.toyota.com/camryeffect/#!/effect/3469/story/favorite_thing]]></url>
						</content>
					</data>;
		}
	}
}
