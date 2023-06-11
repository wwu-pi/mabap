package ag.bpc.mabap.model;

public class Parameter {
	private String type;
	private String name;
	private boolean reference;
	private ObjectType objectType;

	public Parameter(ObjectType objectType, String name) {
		if (objectType != ObjectType.RAISING) {
			throw new IllegalArgumentException("Other types than RAISE must define a TYPE.");
		}
		this.name = name;
		this.reference = true; // raises are always references
		this.objectType = objectType;
	}

	public Parameter(ObjectType objectType, String name, String type) {
		super();
		this.type = type;
		this.name = name;
		this.reference = false; // default is not a reference
		this.objectType = objectType;
	}

	public Parameter(ObjectType objectType, String name, String type, boolean reference) {
		super();
		this.type = type;
		this.name = name;
		this.reference = reference;
		this.objectType = objectType;
	}

	public boolean isReference() {
		return reference;
	}

	public void setReference(boolean reference) {
		this.reference = reference;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ObjectType getObjectType() {
		return objectType;
	}

	public void setObjectType(ObjectType objectType) {
		this.objectType = objectType;
	}
}
