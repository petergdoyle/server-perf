/*
 */
package sample.undertow;

import com.cleverfishsoftware.services.springboot.undertow.ServerPerfApplication;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.zip.GZIPInputStream;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.boot.test.WebIntegrationTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.RestTemplate;

import static org.junit.Assert.assertEquals;

/**
 * Basic integration tests for demo application.
 *
 * @author Ivan Sopov
 * @author Andy Wilkinson
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(ServerPerfApplication.class)
@WebIntegrationTest(randomPort = true)
@DirtiesContext
public class SampleUndertowApplicationTests {

    @Value("${local.server.port}")
    private int port;

    @Test
    public void testHome() throws Exception {
        assertOkResponse("/", "Hello World");
    }

    @Test
    public void testAsync() throws Exception {
        assertOkResponse("/async", "async: Hello World");
    }

    @Test
    public void testCompression() throws Exception {
        HttpHeaders requestHeaders = new HttpHeaders();
        requestHeaders.set("Accept-Encoding", "gzip");
        HttpEntity<?> requestEntity = new HttpEntity<>(requestHeaders);
        RestTemplate restTemplate = new TestRestTemplate();
        ResponseEntity<byte[]> entity = restTemplate.exchange(
                "http://localhost:" + this.port, HttpMethod.GET, requestEntity,
                byte[].class);
        assertEquals(HttpStatus.OK, entity.getStatusCode());
        try (GZIPInputStream inflater = new GZIPInputStream(
                new ByteArrayInputStream(entity.getBody()))) {
            assertEquals("Hello World",
                    StreamUtils.copyToString(inflater, Charset.forName("UTF-8")));
        }
    }

    private void assertOkResponse(String path, String body) {
        ResponseEntity<String> entity = new TestRestTemplate()
                .getForEntity("http://localhost:" + this.port + path, String.class);
        assertEquals(HttpStatus.OK, entity.getStatusCode());
        assertEquals(body, entity.getBody());
    }

}
