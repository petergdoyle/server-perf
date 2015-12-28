package test.backend;

public class Config {

	public Integer getBacklog() {
		return 128;
	}

	public Integer getPort() {
		return 5060;
	}

	public String getHost() {
		return "0.0.0.0";
        }

	public Integer getClientMaxBodySize() {
		return 1048576;
	}

	public Integer getTaskThreadPoolSize() {
		return 30;
	}
}
