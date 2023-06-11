package ag.bpc.mabap.model;

import java.time.LocalDateTime;

public class Package {

	public static final String DEFAULT_TRANSPORT_LAYER = "ZSVH";
	public static final String DEFAULT_SOFTWARE_COMPONENT = "HOME";
	public static final String DEFAULT_NAMESPACE = "/0CUST/";

	String name;
	Package parent;
	String author;
	String description;
	String softwareComponent;
	String namespace;
	String transportLayer;
	LocalDateTime createdAt;
	
	public Package(String name, String author, LocalDateTime createdAt) {
		this.name = name;
		this.author = author;
		this.createdAt = LocalDateTime.now();
	}

	public Package(String name, String parent, String author, String description) {
		this.name = name;
		this.parent = new Package(parent, author, LocalDateTime.now());
		this.author = author;
		this.description = description;
		this.softwareComponent = DEFAULT_SOFTWARE_COMPONENT;
		this.namespace = DEFAULT_NAMESPACE;
		this.transportLayer = DEFAULT_TRANSPORT_LAYER;
		this.createdAt = LocalDateTime.now();
	}

	public Package(String name, String parent, String author, String description, String softwareComponent, String namespace,
			String transportLayer, LocalDateTime createdAt) {
		super();
		this.name = name;
		this.parent = new Package(parent, author, createdAt);
		this.softwareComponent = softwareComponent;
		this.namespace = namespace;
		this.author = author;
		this.description = description;
		this.transportLayer = transportLayer;
		this.createdAt = createdAt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Package getParent() {
		return parent;
	}

	public void setParent(Package parent) {
		this.parent = parent;
	}

	public String getUnit() {
		return softwareComponent;
	}

	public void setUnit(String unit) {
		this.softwareComponent = unit;
	}

	public String getNamespace() {
		return namespace;
	}

	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTransportSystem() {
		return transportLayer;
	}

	public void setTransportSystem(String transportSystem) {
		this.transportLayer = transportSystem;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

}
