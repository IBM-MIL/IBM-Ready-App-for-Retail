package test;



import android.os.RemoteException;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;

public class Testtest extends UiTest {

	

	public Testtest() {
		super("Summit");
	}

	public void testTrue() throws UiObjectNotFoundException, RemoteException {
		
		startApp();
		assertTrue(true);
		
		UiScrollable featuredItems = new UiScrollable(
				new UiSelector()
						.resourceId("com.ibm.mil.readyapps.summit:id/featured_items_pager"));
		
		featuredItems.setAsHorizontalList();
		UiObject app = featuredItems
				.getChild(new UiSelector()
						.resourceId("com.ibm.mil.readyapps.summit:id/fragmentFeatureItemsImageView"));
		app.swipeLeft(5);
		app.swipeLeft(5);
		app.swipeLeft(5);
		app.swipeRight(5);
		app.swipeLeft(5);
		app.swipeRight(5);
		app.swipeRight(5);
		app.swipeRight(5);
		app.swipeLeft(5);
		app.swipeRight(5);

	}
}
