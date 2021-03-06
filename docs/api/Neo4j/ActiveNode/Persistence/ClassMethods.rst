ClassMethods
============




.. toctree::
   :maxdepth: 3
   :titlesonly:


   

   

   

   

   




Constants
---------





Files
-----



  * `lib/neo4j/active_node/persistence.rb:70 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/persistence.rb#L70>`_





Methods
-------


**#create**
  Creates and saves a new node

  .. hidden-code-block:: ruby

     def create(props = {})
       association_props = extract_association_attributes!(props) || {}
     
       new(props).tap do |obj|
         yield obj if block_given?
         obj.save
         association_props.each do |prop, value|
           obj.send("#{prop}=", value)
         end
       end
     end


**#create!**
  Same as #create, but raises an error if there is a problem during save.

  .. hidden-code-block:: ruby

     def create!(*args)
       props = args[0] || {}
       association_props = extract_association_attributes!(props) || {}
     
       new(*args).tap do |o|
         yield o if block_given?
         o.save!
         association_props.each do |prop, value|
           o.send("#{prop}=", value)
         end
       end
     end


**#find_or_create_by**
  Finds the first node with the given attributes, or calls create if none found

  .. hidden-code-block:: ruby

     def find_or_create_by(attributes, &block)
       find_by(attributes) || create(attributes, &block)
     end


**#find_or_create_by!**
  Same as #find_or_create_by, but calls #create! so it raises an error if there is a problem during save.

  .. hidden-code-block:: ruby

     def find_or_create_by!(attributes, &block)
       find_by(attributes) || create!(attributes, &block)
     end


**#load_entity**
  

  .. hidden-code-block:: ruby

     def load_entity(id)
       Neo4j::Node.load(id)
     end





