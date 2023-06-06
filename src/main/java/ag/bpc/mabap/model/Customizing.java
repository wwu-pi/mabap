package ag.bpc.mabap.model;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Customizing {

	/**
	 * Copies a given static customization map to be edited and used in
	 * Customizings.
	 * 
	 * @param staticMap
	 * @return
	 */
	public static Map<String, String> getCustomizationMap(Map<String, String> staticMap) {
		return new LinkedHashMap<String, String>(staticMap);
	}

	private String table;
	private String hash;
	private String client;

	private Map<String, String> values;
	private List<String> keys;

	/**
	 * Creates a new Customizing
	 * 
	 * @param table
	 * @param hash
	 * @param client
	 * @param values
	 * @param keys
	 */
	public Customizing(String table, String hash, String client, Map<String, String> values, List<String> keys) {
		super();
		this.table = table;
		this.hash = hash;
		this.client = client;
		this.values = getCustomizationMap(values);
		this.keys = keys;
	}

	public String getTable() {
		return table;
	}

	public void setTable(String table) {
		this.table = table;
	}

	public String getHash() {
		return hash;
	}

	public void setHash(String hash) {
		this.hash = hash;
	}

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public Map<String, String> getValues() {
		return values;
	}

	public void setValues(Map<String, String> values) {
		this.values = values;
	}

	public List<String> getKeys() {
		return keys;
	}

	public void setKeys(List<String> keys) {
		this.keys = keys;
	}

}
