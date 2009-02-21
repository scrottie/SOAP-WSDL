package helloworld;
import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:test-context.xml"})

public class HelloWorldTest {
	@Autowired
	private Service1Soap soapClient;

	@Test
	public void testClient() {
		assertNotNull(soapClient);
		String result = soapClient.sayHello("Kutter", "Martin");
		assertEquals("Hello Martin Kutter", result);
	}
}
