package test;

import android.os.RemoteException;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiDevice;

public class LandingTest extends UiTest {

	public LandingTest() {
		super("Summit");
	}

	public void testTrue() throws UiObjectNotFoundException, RemoteException {
		quitApp();
		startApp();
		assertTrue(true);

		UiScrollable app = new UiScrollable(
				new UiSelector()
						.resourceId("com.ibm.mil.readyapps.summit:id/featured_items_pager"));

		
		assertTrue(app.swipeLeft(5));
		assertTrue(app.swipeLeft(5));
		assertTrue(app.swipeLeft(5));
		assertTrue(app.swipeLeft(5));
		assertTrue(app.swipeLeft(5));
		UiScrollable recommendedItems = new UiScrollable(
				new UiSelector()
						.resourceId("com.ibm.mil.readyapps.summit:id/recommended_items_pager"));
		recommendedItems.setAsHorizontalList();
		
		
		assertTrue(recommendedItems.scrollToEnd(2));
		
		assertTrue(recommendedItems.scrollToEnd(10));
		assertTrue(recommendedItems.scrollToBeginning(10));
		
		
		recommendedItems.setAsVerticalList();
		assertTrue(recommendedItems.scrollToEnd(2));
		
		UiScrollable shopAll = new UiScrollable(
				new UiSelector()
				.resourceId("com.ibm.mil.readyapps.summit:id/shopall_items_pager"));
		shopAll.setAsHorizontalList();
		assertTrue(shopAll.scrollToEnd(10));
		assertTrue(shopAll.scrollToBeginning(10));
		shopAll.setAsVerticalList();
		shopAll.scrollToBeginning(2);
		
		

	}
}