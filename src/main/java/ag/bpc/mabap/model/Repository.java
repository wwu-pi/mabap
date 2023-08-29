package ag.bpc.mabap.model;

import java.util.ArrayList;
import java.util.List;

public class Repository {

	private String name;
	private List<Class> classes;
	private List<Customization> customizations;
	private List<Package> packages;
	private List<MessageClass> messageClasses;
	private List<LogObject> logObjects;

	public Repository() {
		super();
		this.name = "test-repository";
		this.classes = new ArrayList<Class>();
		this.customizations = new ArrayList<Customization>();
		this.packages = new ArrayList<Package>();
		this.messageClasses = new ArrayList<MessageClass>();
		this.logObjects = new ArrayList<LogObject>();
	}

	public Repository(String name) {
		super();
		this.name = name;
		this.classes = new ArrayList<Class>();
		this.customizations = new ArrayList<Customization>();
		this.packages = new ArrayList<Package>();
		this.messageClasses = new ArrayList<MessageClass>();
		this.logObjects = new ArrayList<LogObject>();
	}

	public Repository(String name, List<Class> classes, List<Customization> customizations, List<Package> packages,
			List<MessageClass> messageClasses, List<LogObject> logObjects) {
		super();
		this.name = name;
		this.classes = classes;
		this.customizations = customizations;
		this.packages = packages;
		this.messageClasses = messageClasses;
		this.logObjects = logObjects;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Class> getClasses() {
		return classes;
	}

	public void setClasses(List<Class> classes) {
		this.classes = classes;
	}

	public void addClas(Class clas) {
		if (this.classes == null) {
			this.classes = new ArrayList<Class>();
		}
		this.classes.add(clas);
	}

	public List<Customization> getCustomizations() {
		return customizations;
	}

	public void setCustomizations(List<Customization> customizations) {
		this.customizations = customizations;
	}

	public void addCustomization(Customization cust) {
		this.customizations.add(cust);
	}

	public List<Package> getPackages() {
		return packages;
	}

	public void setPackages(List<Package> packages) {
		this.packages = packages;
	}

	public void addPackage(Package pkg) {
		this.packages.add(pkg);
	}

	public List<MessageClass> getMessageClasses() {
		return messageClasses;
	}

	public void addMessageClass(MessageClass msgClass) {
		this.messageClasses.add(msgClass);
	}

	public List<LogObject> getLogObjects() {
		return this.logObjects;
	}

	public void addLogObject(LogObject logObject) {
		this.logObjects.add(logObject);
	}

}
