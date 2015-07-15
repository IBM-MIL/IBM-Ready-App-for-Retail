package test;

import android.os.RemoteException;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiDevice;

public class LoginTest extends UiTest{
	private static final long WAIT_TIME = 10000;

	public LoginTest() {
		super("Summit");
		// TODO Auto-generated constructor stub
	}
	public void testTrue() throws UiObjectNotFoundException, RemoteException {
		quitApp();
		startApp();
		
		UiScrollable featuredItems = new UiScrollable(
				new UiSelector()
						.resourceId("com.ibm.mil.readyapps.summit:id/featured_items_pager"));
		featuredItems.setAsHorizontalList();
		featuredItems.swipeRight(5);
		Boolean profileExists = new UiObject(new UiSelector().text("List")).waitForExists(WAIT_TIME);
		assertTrue(profileExists);
		UiObject profileButton= new UiObject(new UiSelector().text("List"));
		profileButton.clickAndWaitForNewWindow();
		UiObject username = new UiObject(new UiSelector().resourceId("com.ibm.mil.readyapps.summit:id/username_field"));
	
		username.setText("user1");
	
		UiObject password = new UiObject(new UiSelector().resourceId("com.ibm.mil.readyapps.summit:id/password_field"));

		password.setText("password1");
	
		UiDevice.getInstance().pressEnter();
		
		UiObject loginButton = new UiObject(new UiSelector().resourceId("com.ibm.mil.readyapps.summit:id/submit_login_button"));

		

		
	}
	

}
