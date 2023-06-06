package ag.bpc.mabap.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MessageClass {
	private String name;
	private String description;
	private String devPackage;
	private String author;
	private LocalDateTime createdAt;
	private List<String> messages;

	MessageClass() {
		this.messages = new ArrayList<String>();
	}

	public MessageClass(String name, String description, String devPackage, String author, LocalDateTime createdAt) {
		super();
		this.name = name;
		this.description = description;
		this.devPackage = devPackage;
		this.author = author;
		this.createdAt = createdAt;

		this.messages = new ArrayList<String>();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDevPackage() {
		return devPackage;
	}

	public void setDevPackage(String devPackage) {
		this.devPackage = devPackage;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public void addMessage(String msg) {
		this.messages.add(msg);
	}

	public List<String> getMessages() {
		return this.messages;
	}

	public int getNumberForMessage(String msg) {
		return this.messages.indexOf(msg);
	}

}
