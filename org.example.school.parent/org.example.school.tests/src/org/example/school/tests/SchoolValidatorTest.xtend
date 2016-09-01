/*
 * generated by Xtext 2.10.0
 */
package org.example.school.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.example.school.school.SchoolModel
import org.example.school.validation.SchoolValidator
import org.junit.Test
import org.junit.runner.RunWith
import org.example.school.school.SchoolPackage

@RunWith(XtextRunner)
@InjectWith(SchoolInjectorProvider)
class SchoolValidatorTest {

	@Inject extension ParseHelper<SchoolModel>
	@Inject extension ValidationTestHelper

	@Test
	def void testStudent() {
		'''
			school "A school" {
				student "A student" registrationNum 100
			}
		'''.parse.assertNoErrors
	}

	@Test
	def void testStudentWithTeacher() {
		'''
			school "A school" {
				student "A student" registrationNum 100 {
					"A teacher"
				}
				teacher "A teacher"
			}
		'''.parse.assertNoIssues
	}

	@Test def void testDuplicateSchools() {
		'''
		school "test" {}
		school "test" {}
		'''.toString.assertDuplicate(SchoolPackage.eINSTANCE.school, "school", "test")
	}

	@Test def void testDuplicateStudents() {
		'''
		school "test" {
			student "astudent" registrationNum 10
			student "astudent" registrationNum 10
		}
		'''.toString.assertDuplicate(SchoolPackage.eINSTANCE.student, "student", "astudent")
	}

	@Test def void testDuplicateTeachers() {
		'''
		school "test" {
			teacher "ateacher"
			teacher "ateacher"
		}
		'''.toString.assertDuplicate(SchoolPackage.eINSTANCE.teacher, "teacher", "ateacher")
	}

	@Test def void testStudentsAndTeachersCanHaveTheSameName() {
		'''
		school "test" {
			teacher "same"
			student "same" registrationNum 10
		}
		'''.parse.assertNoErrors
	}

	@Test
	def void testStudentWithNoTeacher() {
		'''
			school "A school" {
				student "A student" registrationNum 100
				teacher "A teacher"
			}
		'''.parse.assertWarning(
			SchoolPackage.eINSTANCE.student,
			SchoolValidator.STUDENT_WITH_NO_TEACHER,
			"Student A student has no teacher"
		)
	}

	@Test
	def void testStudentWithNoTeacherInASchoolWithNoTeacherIsOk() {
		'''
			school "A school" {
				student "A student" registrationNum 100
			}
		'''.parse.assertNoIssues
	}

	def private void assertDuplicate(String input, EClass type, String desc, String name) {
		input.parse => [
			// check that the error is on both duplicates
			// keeping into consideration the " "
			assertError(type,
				SchoolValidator.DUPLICATE_ELEMENT,
				input.indexOf(name)-1, name.length+2,
				"Duplicate " + desc + " '" + name + "'")
			assertError(type,
				SchoolValidator.DUPLICATE_ELEMENT,
				input.lastIndexOf(name)-1, name.length+2,
				"Duplicate " + desc + " '" + name + "'")
		]
	}
}
