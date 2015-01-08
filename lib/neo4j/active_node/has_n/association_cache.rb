module Neo4j
  module ActiveNode
    module HasN
      # The association cache is a hash available to each node that stores the returned nodes and relationships returned by matching relationships.
      module AssociationCache
        # Clears out the association cache.
        def clear_association_cache #:nodoc:
          association_cache.clear if _persisted_obj
        end

        # Returns the current association cache. It is in the format
        # { :association_name => { :hash_of_cypher_string => [collection] }}
        def association_cache
          @association_cache ||= {}
        end

        # Returns the specified association instance if it responds to :loaded?, nil otherwise.
        # @param [String] cypher_string the cypher, with params, used for lookup
        # @param [Enumerable] association_obj the HasN::Association object used to perform this query
        def association_instance_get(cypher_string, association_obj)
          return if association_cache.nil? || association_cache.empty?
          lookup_obj = cypher_hash(cypher_string)
          reflection = association_reflection(association_obj)
          return if reflection.nil?
          association_cache[reflection.name] ? association_cache[reflection.name][lookup_obj] : nil
        end

        # @return [Hash] A hash of all queries in @association_cache created from the association owning this reflection
        def association_instance_get_by_reflection(reflection_name)
          association_cache[reflection_name]
        end

        # Caches an association result. Unlike ActiveRecord, which stores results in @association_cache using { :association_name => [collection_result] },
        # ActiveNode stores it using { :association_name => { :hash_string_of_cypher => [collection_result] }}.
        # This is necessary because an association name by itself does not take into account :where, :limit, :order, etc,... so it's prone to error.
        # @param [Neo4j::ActiveNode::Query::QueryProxy] query_proxy The QueryProxy object that resulted in this result
        # @param [Enumerable] collection_result The result of the query after calling :each
        # @param [Neo4j::ActiveNode::HasN::Association] association_obj The association traversed to create the result
        def association_instance_set(cypher_string, collection_result, association_obj)
          return collection_result if Neo4j::Transaction.current
          cache_key = cypher_hash(cypher_string)
          reflection = association_reflection(association_obj)
          return if reflection.nil?
          if @association_cache[reflection.name]
            @association_cache[reflection.name][cache_key] = collection_result
          else
            @association_cache[reflection.name] = {cache_key => collection_result}
          end
          collection_result
        end

        # Uses the cypher generated by a QueryProxy object, complete with params, to generate a basic non-cryptographic hash
        # for use in @association_cache.
        # @param [String] the cypher used in the query
        # @return [String] A basic hash of the query
        def cypher_hash(cypher_string)
          cypher_string.hash.abs
        end
      end
    end
  end
end
