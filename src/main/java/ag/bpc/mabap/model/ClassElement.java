package ag.bpc.mabap.model;

abstract public class ClassElement implements IClasElement {
	String name;
	String body;
	Visibility visibility;

	public ClassElement(String name, String body) {
		super();
		this.name = name;
		this.body = body;
		this.visibility = Visibility.PRIVATE; // private is the default visibility
	}

	public ClassElement(String name, String body, Visibility visibility) {
		super();
		this.name = name;
		this.body = body;
		this.visibility = visibility;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public Visibility getVisibility() {
		return visibility;
	}

	public void setVisibility(Visibility visibility) {
		this.visibility = visibility;
	}

}
