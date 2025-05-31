<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* forms/fields/unknown/unknown.html.twig */
class __TwigTemplate_5f7097b36e97a632e3ef179009cd4532c3eb837d5ffaf6013e319d45b8736657 extends \Twig\Template
{
    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        // line 1
        if ($this->getAttribute(($context["field"] ?? null), "fields", [])) {
            // line 2
            echo "    ";
            $this->loadTemplate("forms/fields/array/list.list.twig", "forms/fields/unknown/unknown.html.twig", 2)->display($context);
        } else {
            // line 4
            echo "    ";
            $this->loadTemplate("forms/fields/input/text.html.twig", "forms/fields/unknown/unknown.html.twig", 4)->display($context);
        }
    }

    public function getTemplateName()
    {
        return "forms/fields/unknown/unknown.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  36 => 4,  32 => 2,  30 => 1,);
    }

    /** @deprecated since 1.27 (to be removed in 2.0). Use getSourceContext() instead */
    public function getSource()
    {
        @trigger_error('The '.__METHOD__.' method is deprecated since version 1.27 and will be removed in 2.0. Use getSourceContext() instead.', E_USER_DEPRECATED);

        return $this->getSourceContext()->getCode();
    }

    public function getSourceContext()
    {
        return new Source("", "forms/fields/unknown/unknown.html.twig", "C:\\xampp\\htdocs\\Joomla\\administrator\\components\\com_gantry5\\templates\\forms\\fields\\unknown\\unknown.html.twig");
    }
}
