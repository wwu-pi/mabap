package ag.bpc.mabap.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class Class {

	private String name;
	private String uuid;
	private Package devPackage;
	private String superClass;
	private String author;
	private String description;
	private String client;
	private LocalDateTime createdAt;
	
	private List<Method> methods;
	private List<Attribute> clasAttributes;
	private List<DataType> localDataTypes;

	public Class(String name, String uuid, String devPackage, String superClass, String author, String description,
			String client, LocalDateTime createdAt) {
		super();
		this.name = name;
		this.uuid = uuid;
		this.devPackage = new Package(devPackage, null, null, null);
		this.superClass = superClass;
		this.author = author;
		this.description = description;
		this.client = client;
		this.createdAt = createdAt;
		this.methods = new ArrayList<Method>();
		this.clasAttributes = new ArrayList<Attribute>();
		this.localDataTypes = new ArrayList<DataType>();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getPackage() {
		return devPackage.getName();
	}

	public void setPackage(String devPackage) {
		this.devPackage.setName(devPackage);
	}

	public String getSuperClass() {
		return superClass;
	}

	public void setSuperClass(String superClass) {
		this.superClass = superClass;
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

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public List<Method> getMethods() {
		return methods;
	}

	public void addMethod(Method method) {
		if (this.methods == null) {
			this.methods = new ArrayList<Method>();
		}
		this.methods.add(method);
	}

	public void setMethods(List<Method> methods) {
		this.methods = methods;
	}

	public List<Method> getPublicMethods() {
		return this.methods.stream().filter(m -> m.getVisibility() == Visibility.PUBLIC)
				.collect(Collectors.toList());
	}

	public List<Method> getProtectedMethods() {
		return this.methods.stream().filter(m -> m.getVisibility() == Visibility.PROTECTED)
				.collect(Collectors.toList());
	}

	public List<Method> getPrivateMethods() {
		return this.methods.stream().filter(m -> m.getVisibility() == Visibility.PRIVATE)
				.collect(Collectors.toList());
	}

	public List<Method> getRedefinedMethods() {
		return this.methods.stream().filter(m -> m.isRedefinition() == true).collect(Collectors.toList());
	}

	public List<Method> getNotRedefinedMethods() {
		return this.methods.stream().filter(m -> !m.isRedefinition() == true).collect(Collectors.toList());
	}

	public List<DataType> getLocalDataTypes() {
		return localDataTypes;
	}

	public void setLocalDataTypes(List<DataType> localDataTypes) {
		this.localDataTypes = localDataTypes;
	}

	public void addLocalDataType(DataType localDataType) {
		if (this.localDataTypes == null) {
			this.localDataTypes = new ArrayList<DataType>();
		}
		this.localDataTypes.add(localDataType);
	}

	public List<DataType> getPublicLocalDataTypes() {
		return this.localDataTypes.stream().filter(m -> m.getVisibility() == Visibility.PUBLIC)
				.collect(Collectors.toList());
	}

	public List<DataType> getProtectedLocalDataTypes() {
		return this.localDataTypes.stream().filter(m -> m.getVisibility() == Visibility.PROTECTED)
				.collect(Collectors.toList());
	}

	public List<DataType> getPrivateLocalDataTypes() {
		return this.localDataTypes.stream().filter(m -> m.getVisibility() == Visibility.PRIVATE)
				.collect(Collectors.toList());
	}

	public List<Attribute> getClasAttributes() {
		return clasAttributes;
	}

	public void setClasAttributes(List<Attribute> clasAttributes) {
		this.clasAttributes = clasAttributes;
	}

	public void addClasAttribute(Attribute clasAttribute) {
		if (this.clasAttributes == null) {
			this.clasAttributes = new ArrayList<Attribute>();
		}
		this.clasAttributes.add(clasAttribute);
	}

	public List<Attribute> getPublicClassAttributes() {
		return this.clasAttributes.stream().filter(m -> m.getVisibility() == Visibility.PUBLIC)
				.collect(Collectors.toList());
	}

	public List<Attribute> getProtectedClassAttributes() {
		return this.clasAttributes.stream().filter(m -> m.getVisibility() == Visibility.PROTECTED)
				.collect(Collectors.toList());
	}

	public List<Attribute> getPrivateClassAttributes() {
		return this.clasAttributes.stream().filter(m -> m.getVisibility() == Visibility.PRIVATE)
				.collect(Collectors.toList());
	}

	public boolean anyMethodWithParametersOrRaises() {
		boolean anyMethodsWithAttributes = this.methods.stream().filter(m -> m.getAllParameters().size() > 0)
				.collect(Collectors.toList()).size() > 0;

		boolean anyMethodsWithRaises = this.methods.stream().filter(m -> m.getRaises().size() > 0)
				.collect(Collectors.toList()).size() > 0;

		return anyMethodsWithAttributes || anyMethodsWithRaises;
	}

	public List<IClasElement> getClasElements() {
		ArrayList<IClasElement> allClasElements = new ArrayList<IClasElement>();
		allClasElements.addAll(getClasAttributes());
		allClasElements.addAll(getLocalDataTypes());
		allClasElements.addAll(getNotRedefinedMethods());
		return allClasElements;
	}

	public List<IClasElement> getSortedClasElements() {
		return getClasElements().stream().sorted(Comparator.comparing(x -> x.getName(), String::compareToIgnoreCase))
				.collect(Collectors.toList());
	}

	/**
	 * Return the index of a ClasElement depending on its visibility.
	 * 
	 * list = [ attr1: public, attr2: protected, attr3: public ]
	 * list.getEditOrderOfClasElement(attr2) -> 1
	 * list.getEditOrderOfClasElement(attr3) -> 2
	 * 
	 * @param element
	 * @return indexOfElement
	 */
	public int getEditOrderOfClasElement(IClasElement element) {
		if (element instanceof Attribute) {
			return this.clasAttributes.stream().filter(m -> m.getVisibility() == element.getVisibility())
					.collect(Collectors.toList()).indexOf(element) + 1;
		}
		if (element instanceof DataType) {
			return this.localDataTypes.stream().filter(m -> m.getVisibility() == element.getVisibility())
					.collect(Collectors.toList()).indexOf(element) + 1;
		}
		if (element instanceof Method) {
			return this.methods.stream().filter(m -> m.getVisibility() == element.getVisibility())
					.collect(Collectors.toList()).indexOf(element) + 1;
		}
		return -1;
	}
}
