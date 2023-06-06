package ag.bpc.mabap.model;

public class LogObject {
	private String sstID;
	private String description;
	private String parentObject;
	private String hash;

	public LogObject(String sstID, String description) {
		super();
		this.sstID = sstID;
		this.description = description;
		this.parentObject = "ZGSST"; // this should be always the case for ZGSST interfaces
		this.hash = "uA0Io4san8Co7/jVdFtfWjnH3xU="; // TODO: compute this
	}

	public LogObject(String sstID, String description, String parentObject, String hash) {
		super();
		this.sstID = sstID;
		this.description = description;
		this.parentObject = parentObject;
		this.hash = hash;
	}

	public String getSstID() {
		return sstID;
	}

	public void setSstID(String sstID) {
		this.sstID = sstID;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getParentObject() {
		return parentObject;
	}

	public void setParentObject(String parentObject) {
		this.parentObject = parentObject;
	}

	public String getHash() {
		return hash;
	}

	public void setHash(String hash) {
		this.hash = hash;
	}
}
