DateConverter
=============




.. toctree::
   :maxdepth: 3
   :titlesonly:


   

   

   




Constants
---------





Files
-----



  * `lib/neo4j/shared/type_converters.rb:4 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/shared/type_converters.rb#L4>`_





Methods
-------


**#convert_type**
  

  .. hidden-code-block:: ruby

     def convert_type
       Date
     end


**#to_db**
  

  .. hidden-code-block:: ruby

     def to_db(value)
       Time.utc(value.year, value.month, value.day).to_i
     end


**#to_ruby**
  

  .. hidden-code-block:: ruby

     def to_ruby(value)
       Time.at(value).utc.to_date
     end





