package ag.bpc.mabap.model;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class Method extends ClassElement {
	boolean redefinition;
	ArrayList<Parameter> parameters;

	public Method(String name, Visibility visibility) {
		// redefined methods do no declare their imports / exports
		super(name, "", visibility);
		this.redefinition = false;

		this.parameters = new ArrayList<Parameter>();
		this.setBody(""); // sets default if none was given
	}

	public Method(String name, Visibility visibility, boolean redefinition) {
		// redefined methods do no declare their imports / exports
		super(name, "", visibility);
		this.redefinition = redefinition;

		this.parameters = new ArrayList<Parameter>();
		this.setBody(""); // sets default if none was given
	}

	public Method(String name, Visibility visibility, boolean redefinition, String body) {
		// redefined methods do no declare their imports / exports
		super(name, body, visibility);
		this.redefinition = redefinition;

		this.parameters = new ArrayList<Parameter>();

		this.setBody(body); // applies custom logic to body
	}

	public boolean isRedefinition() {
		return redefinition;
	}

	public void setRedefinition(boolean redefinition) {
		this.redefinition = redefinition;
	}

	public List<Parameter> getImports() {
		return this.parameters.stream().filter(p -> p.getObjectType() == ObjectType.IMPORT)
				.collect(Collectors.toList());
	}

	public void addImportFromParams(String name, String type) {
		this.parameters.add(new Parameter(ObjectType.IMPORT, name, type));
	}

	public void addImportFromParams(String name, String type, boolean reference) {
		this.parameters.add(new Parameter(ObjectType.IMPORT, name, type, reference));
	}

	public List<Parameter> getExports() {
		return this.parameters.stream().filter(p -> p.getObjectType() == ObjectType.EXPORT)
				.collect(Collectors.toList());
	}

	public void addExport(Parameter export) {
		this.parameters.add(export);
	}

	public void addExportFromParams(String name, String type) {
		this.parameters.add(new Parameter(ObjectType.EXPORT, name, type));
	}

	public void addExportFromParams(String name, String type, boolean reference) {
		this.parameters.add(new Parameter(ObjectType.EXPORT, name, type, reference));
	}

	public List<Parameter> getImportsAndExports() {
		ArrayList<Parameter> params = new ArrayList<Parameter>();
		params.addAll(this.getImports());
		params.addAll(this.getExports());
		return params;
	}

	public ArrayList<Parameter> getAllParameters() {
		return this.parameters;
	}

	public List<Parameter> getSortedParameters() {
		return this.parameters.stream().sorted(Comparator.comparing(x -> x.getName(), String::compareToIgnoreCase))
				.collect(Collectors.toList());
	}

	public List<Parameter> getRaises() {
		return this.parameters.stream().filter(p -> p.getObjectType() == ObjectType.RAISE)
				.collect(Collectors.toList());
	}

	public void addRaise(String raiseName) {
		this.parameters.add(new Parameter(ObjectType.RAISE, raiseName));
	}

	public void setBody(String body) {
		// initialize empty method body if none was given
		if (body.length() == 0) {
			this.body = "METHOD " + this.name + ".\r\nENDMETHOD.\r\n";
		} else {
			this.body = body;
		}
	}

	/**
	 * Returns the Edit Order of a parameter. The Edit Order is determined for
	 * Import/Exports and Raises separately. Also, Export are always listed after
	 * Imports.
	 * 
	 * list = [ param1: export, param2: imports, param3: raise ]
	 * list.getEditOrderOfParam(param1) -> 2 list.getEditOrderOfParam(param2) -> 1
	 * list.getEditOrderOfParam(param3) -> 1
	 * 
	 * @param param
	 * @return
	 */
	public int getEditOrderOfParam(Parameter param) {
		if (param.getObjectType() == ObjectType.RAISE) {
			return this.getRaises().indexOf(param) + 1;
		}
		return this.getImportsAndExports().indexOf(param) + 1;
	}
}
