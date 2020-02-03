/**
 * Created by David Hurtado.
 */
public class CacheHandler {
	private String namespace;
	private String busname;
	private Cache.OrgPartition part;
	private static CacheHandler ch;
	private final String defaultBusname = 'default';
	private final String defaultNamespace = 'local';

	/**
	 * Default constructor
	 */
	public CacheHandler(){
		this.setNamespace('');
		this.setBusname('');
		this.part = new Cache.OrgPartition(this.getNamespace() + '.' + this.getBusname());
	}

	/**
	 * Constructor with namespace
	 */
	public CacheHandler(String namespace){
		this.setNamespace(namespace);
		this.setBusname('');
		this.part = new Cache.OrgPartition(this.getNamespace() + '.' + this.getBusname());
	}

	/**
	 * Constructor with namespace and busname
	 */
	public CacheHandler(String namespace, String busname){
		this.setNamespace(namespace);
		this.setBusname(busname);
		this.part = new Cache.OrgPartition(this.getNamespace() + '.' + this.getBusname());
	}

	/**
	 * Method to get the instance value of a key
	 */
	public object retrieve(String key){
		return this.getPart().get(key);
	}

	/**
	 * Method to set the key - value in an instance
	 */
	public void put(String key, Object value){
			this.getPart().put(key, value);
	}

	/* = = = = = =  = = = = = =  Static Handling = = = = = = = = = = = = */

	/**
	 * Method to set an instance of itself in a static class attribuce
	 */
	public static void start(){
		CacheHandler.ch = CacheHandler.ch != null ? CacheHandler.ch : new CacheHandler();
	}

	/**
	 * Method to staticly get the value of a key
	 */
	public static object get(String key){
		CacheHandler.start();
		return CacheHandler.ch.retrieve(key);
	}

	/**
	 *  Method to set the key - value in an static instance (default)
	 */
	public static void set(String key, Object value){
		CacheHandler.start();
		CacheHandler.ch.getPart().put(key, value);
	}


	/* = = = = = =  = = = = = =  Getters and Setters = = = = = = = = = = = = */

	/**
	 * Get the namespace
	 */
	public String getNamespace() {
		return namespace;
	}

	/**
	 * Get the busname
	 */
	public String getBusname() {
		return busname;
	}

	/**
	 * Get the Cache.OrgPartition
	 */
	public Cache.OrgPartition getPart() {
		return part;
	}

	/**
	 * Set the namespace
	 */
	public void setNamespace(String namespace) {
		if(String.isBlank(namespace)){
			this.namespace = defaultNamespace;
		} else{
			this.namespace = namespace;
		}
	}

	/**
	 * Set the busname
	 */
	public void setBusname(String busname) {
		if(String.isBlank(busname)){
			this.busname = this.defaultBusname;
		} else{
			this.busname = busname;
		}
	}
}