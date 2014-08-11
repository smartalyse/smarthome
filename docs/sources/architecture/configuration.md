# Declaring Configurations, Bindings and Things 

Specific services and bindings have to provide meta information which are used for visualization, validation or internal service mapping. Meta information can be provided by registering specific services at the *OSGi* service registry or by specifying them in a declarative way, which is described in this chapter.

<b>Three kinds of descriptions/definitions exist:</b>

- Configuration descriptions: Used for visualization and validation of configuration properties (optional)
- Binding definitions: Required to declare a binding (mandatory)
- Bridge and *Thing* descriptions: Required to specify which bridges and *Thing*s are provided by the binding, which relations they have to each other and which channels they offer (mandatory) 


## Configuration Descriptions

Specific services or bindings require usually a configuration to be operational in a meaningful way. To visualize or validate concrete configuration properties, configuration descriptions should be provided. All available configuration descriptions are accessible through the `org.eclipse.smarthome.config.core.ConfigDescriptionRegistry` service.

Although configuration descriptions are usually specified in a declarative way (as described in this section), they can also be provided as `org.eclipse.smarthome.config.core.ConfigDescriptionProvider`.
Any `ConfigDescriptionProvider`s must be registered as service at the *OSGi* service registry. The full Java API for configuration descriptions can be found in the Java package `org.eclipse.smarthome.config.core`.

Configuration descriptions must be placed as XML file(s) (with the ending `.xml`) in the bundle's folder `/ESH-INF/config/`.


### XML Structure for Configuration Descriptions

    <?xml version="1.0" encoding="UTF-8"?>
    <config-description:config-descriptions
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:config-description="http://eclipse.org/smarthome/schemas/config-description/v1.0.0"
        xsi:schemaLocation="http://eclipse.org/smarthome/schemas/config-description/v1.0.0
            http://eclipse.org/smarthome/schemas/config-description-1.0.0.xsd">

      <config-description uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:...">
        <parameter name="String" type="{text|integer|decimal|boolean}">
          <context>{network_address|password|email}</context>
          <required>{true|false}</required>
          <default>String</default>
          <label>String</label>
          <description>String</description>
        </parameter>
      </config-description>

      <config-description uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:...">
        ...
      </config-description>

      ...

    </config-description:config-descriptions>

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>config-description.uri</td><td>The URI of this description within the ConfigDescriptionRegistry (mandatory).</td></tr>
  <tr><td>parameter</td><td>The description of a concrete configuration parameter (optional).</td></tr>
  <tr><td>parameter.name</td><td>The name of the configuration parameter (mandatory).</td></tr>
  <tr><td>parameter.type</td><td>The data type of the configuration parameter (mandatory).</td></tr>
  <tr><td>context</td><td>The context of the configuration parameter (optional).</td></tr>
  <tr><td>required</td><td>The flag indicating if the configuration parameter has to be set or not (optional, default: false).</td></tr>
  <tr><td>default</td><td>The default value of the configuration parameter (optional).</td></tr>
  <tr><td>label</td><td>A human readable label for the configuration parameter (optional).</td></tr>
  <tr><td>description</td><td>A human readable description for the configuration parameter (optional).</td></tr>
</table>

The full XML schema for configuration descriptions is specified in the [ESH config description XSD](http://eclipse.org/smarthome/schemas/config-description-1.0.0.xsd) file.

<b>Hints:</b>

- Although the attribute `uri` is optional, it *must* be specified in configuration description files. Only for embedded configuration descriptions in documents for binding definitions and `Thing` type descriptions, the attribute is optional.


### Example

The following code gives an example for one configuration description.  

    <?xml version="1.0" encoding="UTF-8"?>
    <config-description:config-description uri="bridge-type://my-great-binding:my-bridge-name"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:config-description="http://eclipse.org/smarthome/schemas/config-description/v1.0.0"
        xsi:schemaLocation="http://eclipse.org/smarthome/schemas/config-description/v1.0.0
            http://eclipse.org/smarthome/schemas/config-description-1.0.0.xsd">

      <parameter name="ipAddress" type="text">
        <context>network_address</context>
        <label>Network Address</label>
        <description>Network address of the device.</description>
        <required>true</required>
      </parameter>

      <parameter name="userName" type="text">
        <label>User Name</label>
        <required>true</required>
      </parameter>

      <parameter name="password" type="text">
        <context>password</context>
        <required>false</required>
      </parameter>

    </config-description:config-description>


## Binding Definitions

Every binding has to provide meta information such as author or description. The meta information of all bindings is accessible through the `org.eclipse.smarthome.core.binding.BindingInfoRegistry` service.

Although binding definitions are usually specified in a declarative way (as described in this section), they can also be provided as `org.eclipse.smarthome.core.binding.BindingInfo`.
Any `BindingInfo` must be registered as service at the *OSGi* service registry. The full Java API for binding definitions can be found in the Java package `org.eclipse.smarthome.core.binding`.

Binding definitions must be placed as XML file(s) (with the ending `.xml`) in the bundle's folder `/ESH-INF/binding/`.


### XML Structure for Binding Definitions

    <?xml version="1.0" encoding="UTF-8"?>
    <binding:binding id="bindingID"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:binding="http://eclipse.org/smarthome/schemas/binding/v1.0.0"
        xsi:schemaLocation="http://eclipse.org/smarthome/schemas/binding/v1.0.0
            http://eclipse.org/smarthome/schemas/binding-1.0.0.xsd">

      <name>String</name>
      <description>String</description>
      <author>String</author>

      <config-description>
        ...
      </config-description>

      OR

      <config-description-ref uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:..."/>

    </binding:binding>

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>binding.id</td><td>An identifier for the binding (mandatory).</td></tr>
  <tr><td>name</td><td>A human readable name for the binding (mandatory).</td></tr>
  <tr><td>description</td><td>A human readable description for the binding (optional).</td></tr>
  <tr><td>author</td><td>The author of the binding (mandatory).</td></tr>
  <tr><td>config-description</td><td>The configuration description for the binding within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref</td><td>The reference to a configuration description for the binding within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref.uri</td><td>The URI of the configuration description for the binding within the ConfigDescriptionRegistry (mandatory).</td></tr>
</table>

The full XML schema for binding definitions is specified in the [ESH binding XSD](http://eclipse.org/smarthome/schemas/binding-1.0.0.xsd) file.

<b>Hints:</b>

- The attribute `uri` in the section `config-description` is optional, it *should not* be specified in binding definition files because it's an embedded configuration. If the `uri` is *not* specified, the configuration description is registered as `binding://bindingID`, otherwise the given `uri` is used.
- If a configuration description is already specified somewhere else and the binding wants to (re-)use it, a `config-description-ref` should be used instead.


### Example

The following code gives an example for a binding definition.  

    <?xml version="1.0" encoding="UTF-8"?>
    <binding:binding id="hue"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:binding="http://eclipse.org/smarthome/schemas/binding/v1.0.0"
        xsi:schemaLocation="http://eclipse.org/smarthome/schemas/binding/v1.0.0
            http://eclipse.org/smarthome/schemas/binding-1.0.0.xsd">

      <name>hue Binding</name>
      <description>The hue Binding integrates the Philips hue system. It allows to control hue bulbs.</description>
      <author>ACME</author>

    </binding:binding>


## Bridges and Thing Descriptions

Every binding has to provide meta information about which bridges and/or *Thing*s it provides and how their relations to each other are. In that way a binding could describe that it requires specific bridges to be operational or define which channels (e.g. temperature, color, etc.) it provides.

Every bridge or *Thing* has to provide meta information such as label or description. The meta information of all bridges and *Thing*s is accessible through the `org.eclipse.smarthome.core.thing.binding.ThingTypeProvider` service.

Bridge and *Thing* descriptions must be placed as XML file(s) (with the ending `.xml`) in the bundle's folder `/ESH-INF/thing/`. The full Java API for bridge and *Thing* descriptions can be found in the Java package `org.eclipse.smarthome.core.thing.type`.


### XML Structure for Thing Descriptions

    <?xml version="1.0" encoding="UTF-8"?>
    <thing:thing-descriptions bindingId="bindingID"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:thing="http://eclipse.org/smarthome/schemas/thing-description/v1.0.0"
        xsi:schemaLocation="http://eclipse.org/smarthome/schemas/thing-description/v1.0.0
            http://eclipse.org/smarthome/schemas/thing-description-1.0.0.xsd">

      <bridge-type id="bridgeTypeID">
        <supported-bridge-type-refs>
          <bridge-type-ref id="bridgeTypeID" />
          ...
        </supported-bridge-type-refs>

        <label>String</label>
        <description>String</description>

        <channels>
          <channel id="channelID" typeId="channelTypeID" />
          ...
        </channels>

        <config-description>
          ...
        </config-description>

        OR

        <config-description-ref uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:..."/>
      </bridge-type>

      <thing-type id="thingTypeID">
        <supported-bridge-type-refs>
          <bridge-type-ref id="bridgeTypeID" />
          ...
        </supported-bridge-type-refs>

        <label>String</label>
        <description>String</description>

        <channels>
          <channel id="channelID" typeId="channelTypeID" />
          ...
        </channels>

        <config-description>
          ...
        </config-description>

        OR

        <config-description-ref uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:..."/>
      </thing-type>

      <channel-type id="channelTypeID">
        <item-type>Dimmer</item-type>
        <label>String</label>
        <description>String</description>

        <config-description>
          ...
        </config-description>

        OR

        <config-description-ref uri="{binding|thing-type|bridge-type|channel-type|any_other}://bindingID:..."/>
      </channel-type>   

      ...

    </thing:thing-descriptions>

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>thing-descriptions.bindingId</td><td>The identifier of the binding this types belong to (mandatory).</td></tr>
</table>
<p>
<b>Bridges and Things:</b>
<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>bridge-type.id | thing-type.id</td><td>An identifier for the bridge/<i>Thing</i> type (mandatory).</td></tr>
  <tr><td>supported-bridge-type-refs</td><td>The identifiers of the bridges this bridge/<i>Thing</i> can connect to (optional).</td></tr>
  <tr><td>bridge-type-ref.id</td><td>The identifier of a bridge this bridge/<i>Thing</i> can connect to (mandatory).</td></tr>
  <tr><td>label</td><td>A human readable label for the bridge/<i>Thing</i> (mandatory).</td></tr>
  <tr><td>description</td><td>A human readable description for the bridge/<i>Thing</i> (optional).</td></tr>
  <tr><td>channels</td><td>The channels the bridge/<i>Thing</i> provides (optional).</td></tr>
  <tr><td>channel.id</td><td>An identifier of the channel the bridge/<i>Thing</i> provides (mandatory).</td></tr>
  <tr><td>channel.typeId</td><td>An identifier of the channel type definition the bridge/<i>Thing</i> provides (mandatory).</td></tr>
  <tr><td>config-description</td><td>The configuration description for the bridge/<i>Thing</i> within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref</td><td>The reference to a configuration description for the bridge/<i>Thing</i> within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref.uri</td><td>The URI of the configuration description for the bridge/<i>Thing</i> within the ConfigDescriptionRegistry (mandatory).</td></tr>
</table>
<p>
<b>Channels:</b>
<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>channel-type.id</td><td>An identifier for the channel type (mandatory).</td></tr>
  <tr><td>item-type</td><td>An item type of the channel (mandatory). All item types are specified in <code>ItemFactory</code> instances. The following items belong to the core: <code>Switch, Rollershutter, Contact, String, Number, Dimmer, DateTime, Color, Image</code>.</td></tr>
  <tr><td>label</td><td>A human readable label for the channel (mandatory).</td></tr>
  <tr><td>description</td><td>A human readable description for the channel (optional).</td></tr>
  <tr><td>config-description</td><td>The configuration description for the channel within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref</td><td>The reference to a configuration description for the channel within the ConfigDescriptionRegistry (optional).</td></tr>
  <tr><td>config-description-ref.uri</td><td>The URI of the configuration description for the channel within the ConfigDescriptionRegistry (mandatory).</td></tr>
</table>

The full XML schema for *Thing* type descriptions is specified in the <a href="http://eclipse.org/smarthome/schemas/thing-description-1.0.0.xsd">ESH thing description XSD</a> file.

<b>Hints:</b>

- Any identifiers of the types are automatically mapped to unique identifiers: `bindingID:id`.
- The attribute `uri` in the section `config-description` is optional, it *should not* be specified in bridge/*Thing*/channel type definition files because it's an embedded configuration. If the `uri` is *not* specified, the configuration description is registered as `bridge-type://bindingID:id`, `thing-type://bindingID:id` or `channel-type://bindingID:id` otherwise the given `uri` is used.
- If a configuration description is already specified somewhere else and the bridge/*Thing*/channel type wants to (re-)use it, a `config-description-ref` should be used instead.