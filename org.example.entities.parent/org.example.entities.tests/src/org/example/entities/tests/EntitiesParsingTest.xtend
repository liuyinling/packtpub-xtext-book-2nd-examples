/*
 * generated by Xtext 2.9.1
 */
package org.example.entities.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.example.entities.entities.EntityType
import org.example.entities.entities.Model
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(EntitiesInjectorProvider)
class EntitiesParsingTest {

	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper

	@Test
	def void testParsing() {
		val model = '''
			entity MyEntity {
			    MyEntity attribute;
			}
		'''.parse

		val entity = model.entities.get(0)
		Assert.assertEquals("MyEntity", entity.name)

		val attribute = entity.attributes.get(0)
		Assert.assertEquals("attribute", attribute.name);
		Assert.assertEquals("MyEntity", (attribute.type.elementType as EntityType).entity.name);
	}

	@Test
	def void testCorrectParsing() {
		'''
			entity MyEntity {
			    MyEntity attribute;
			}
		'''.parse.assertNoErrors
	}
}
