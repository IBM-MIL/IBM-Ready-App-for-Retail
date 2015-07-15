package test;

import android.os.RemoteException;

import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

/**
 * 
 * @author jpetitt
 * 
 *         Each app should have a test class that extends UiTest. UiTest
 *         provides functionality that can be used for testing across all apps.
 */

public class UiTest extends UiAutomatorTestCase {

	/**
	 * The default timeout for UI tests is 10 seconds.
	 */
	protected final int TIMEOUT = 10000;
	private static final long WAIT_TIME = 10000;

	private String appName;

	/**
	 * 
	 * Each subclass of UiTest should call this constructor, passing it the name
	 * of the app that it is testing.
	 * 
	 * @param appName
	 *            The name of the app your are testing.
	 */
	public UiTest(String appName) {
		super();
		this.appName = appName;
	}

	/**
	 * 
	 * Attempts to launch the targeted app.
	 * 
	 * @throws UiObjectNotFoundException
	 * @throws RemoteException 
	 */
	
	protected void startApp() throws UiObjectNotFoundException, RemoteException {
		int width = UiDevice.getInstance().getDisplayWidth();
		int height = UiDevice.getInstance().getDisplayHeight();
		
		UiDevice.getInstance().swipe(width/2,height/2, width/2, 0, 5);
		

		Boolean okExists = new UiObject(new UiSelector().text("OK")).waitForExists(WAIT_TIME);
		UiObject okButton; 
		if(okExists==true){
			okButton = new UiObject(new UiSelector().text("OK"));
			okButton.clickAndWaitForNewWindow();
		}
	
		
		getUiDevice().pressHome();

		// click all apps button
		UiObject allAppsButton = new UiObject(
				new UiSelector().description("Apps"));
		allAppsButton.clickAndWaitForNewWindow();
		
		okExists = new UiObject(new UiSelector().text("OK")).waitForExists(WAIT_TIME);
		if(okExists==true){
			okButton = new UiObject(new UiSelector().text("OK"));
			okButton.clickAndWaitForNewWindow();
		}
	
		

		// click apps tab (as opposed to widgets tab)
		UiObject appsTab = new UiObject(new UiSelector().text("Apps"));
		appsTab.click();

		// enable horizontal scrolling within apps tab
		UiScrollable appsView = new UiScrollable(
				new UiSelector().scrollable(true));
		appsView.setAsHorizontalList();

		// click on targeted app
		UiObject app = appsView.getChildByText(new UiSelector()
				.className(android.widget.TextView.class.getName()), appName);
		app.clickAndWaitForNewWindow();
	}

	/**
	 * 
	 * Attempts to clear the targeted app's data.
	 * 
	 * @throws UiObjectNotFoundException
	 * @throws RemoteException 
	 */
	protected void clearData() throws UiObjectNotFoundException, RemoteException {
		getUiDevice().pressHome();

		// temporarily change app target to Settings
		String origAppName = appName;
		appName = "Settings";

		try {
			startApp();
		} catch (UiObjectNotFoundException e) {
			appName = origAppName;
			e.printStackTrace();
		}

		appName = origAppName; // restore targeted app name

		// scroll through settings list and find Apps
		UiScrollable settingsList = new UiScrollable(
				new UiSelector().className(android.widget.ListView.class
						.getName()));
		UiObject appsSetting = settingsList.getChildByText(new UiSelector()
				.className(android.widget.TextView.class.getName()), "Apps");
		appsSetting.clickAndWaitForNewWindow();

		// scroll through list of apps and find targeted app
		UiScrollable appsList = new UiScrollable(
				new UiSelector().className(android.widget.ListView.class
						.getName()));
		UiObject app = appsList.getChildByText(new UiSelector()
				.className(android.widget.TextView.class.getName()), appName);
		app.clickAndWaitForNewWindow();

		// scroll through targeted app's settings and find Clear data button
		UiScrollable targetAppSettings = new UiScrollable(
				new UiSelector().className(android.widget.ScrollView.class
						.getName()));
		UiObject clearData = targetAppSettings
				.getChildByText(new UiSelector()
						.className(android.widget.Button.class.getName()),
						"Clear data");

		// clear data if its enabled
		if (clearData.isEnabled()) {
			clearData.clickAndWaitForNewWindow();
			UiObject confirmClear = new UiObject(new UiSelector().text("OK"));
			confirmClear.clickAndWaitForNewWindow();
		}
	}

	/**
	 * 
	 * Sets airplane mode to on or off depending on the boolean value passed to
	 * the method. If the intended mode is already active then the mode won't be
	 * changed.
	 * 
	 * Note: tests that turn airplane mode on should recall this method before
	 * the end of their test to turn it back off to prevent subsequent tests
	 * from failing.
	 * 
	 * @param enable
	 *            Determines whether airplane mode should be on or off.
	 * @throws UiObjectNotFoundException
	 * @throws RemoteException 
	 */
	protected void setAirplaneMode(boolean enable)
			throws UiObjectNotFoundException, RemoteException {

		getUiDevice().pressHome();

		// temporarily change targeted app to Settings
		String origAppName = appName;
		appName = "Settings";

		try {
			startApp();
		} catch (UiObjectNotFoundException e) {
			appName = origAppName;
			e.printStackTrace();
		}

		appName = origAppName; // restore targeted app name

		// scroll through Settings and find More...
		UiScrollable settingsList = new UiScrollable(
				new UiSelector().className(android.widget.ListView.class
						.getName()));
		UiObject moreSettings = settingsList.getChildByText(new UiSelector()
				.className(android.widget.TextView.class.getName()), "More���������������������������");
		moreSettings.clickAndWaitForNewWindow();

		// select airplane mode checkbox
		UiScrollable networkSettingsList = new UiScrollable(
				new UiSelector().className(android.widget.ListView.class
						.getName()));
		UiObject airplaneMode = networkSettingsList.getChild(new UiSelector()
				.className(android.widget.CheckBox.class.getName()));

		// turn airplane mode on/off
		if (enable) {
			// turn airplane mode on
			if (!airplaneMode.isChecked()) {
				// currently off, turn on
				airplaneMode.click();
			}
		} else {
			if (airplaneMode.isChecked()) {
				// currently on, turn off
				airplaneMode.click();
			}
		}
	}

	/**
	 * 
	 
	 * @throws RemoteException 
	 * @throws UiObjectNotFoundException 
	 */
	protected void quitApp() throws RemoteException, UiObjectNotFoundException {
		UiDevice.getInstance().pressRecentApps();
		Boolean recentAppExists = new UiObject(new UiSelector().text("Summit")).waitForExists(WAIT_TIME);
		if(recentAppExists==true){
			UiObject app = new UiObject(new UiSelector().text("Summit"));
			app.swipeRight(5);
		}
		
		UiDevice.getInstance().pressHome();
	}

	
}
