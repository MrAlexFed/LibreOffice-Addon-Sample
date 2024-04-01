from uitest.framework import UITestCase
import time

class SimpleTest(UITestCase):
	def test_open_dialog(self):
		with self.ui_test.create_doc_in_start_center("writer"):
			with self.ui_test.execute_dialog_through_command("cybersecurity.irm.libreoffice.addon.url.protocol:RadioButton1Cmd", close_button="cancel"):
				time.sleep(1)
		